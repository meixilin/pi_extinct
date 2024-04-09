# Title: reproduce extinction simulations
# Author: Meixi Lin
# Date: Sat Apr  6 12:52:26 2024

# preparation --------
rm(list = ls())
cat("\014")
options(echo = TRUE, stringsAsFactors = FALSE, warn = 1)

setwd("/Users/linmeixi/AMoiLab/mar_related/pi_extinct")

library(mar)
library(ggplot2)
library(dplyr)
sessionInfo()

# def functions --------
check_file <- function(myspecies) {
    genemapf = paste0('./data-raw/tmpobjects/genemaps-', myspecies, '.rda')
    simf = paste0('./data-raw/tmpobjects/extinctionsim-', myspecies, '.rda')
    passcheck = TRUE
    if(!file.exists(genemapf)) {
        warning(paste0(genemapf, ' does not exist'))
        passcheck = FALSE
    }
    if(!file.exists(simf)) {
        warning(paste0(simf, ' does not exist'))
        passcheck = FALSE
    }
    return(passcheck)
}

check_xsim <- function(myspecies) {
    mycols = c("thetaw","pi","M","E","N","a","asub","ax","mx","type")
    simf = paste0('./data-raw/tmpobjects/extinctionsim-', myspecies, '.rda')
    load(simf)
    message(paste0(colnames(xsim), collapse = ';'))
    passcheck=TRUE
    # if there is any missing
    if (ncol(xsim)!=length(mycols)) {
        warning(paste0(myspecies, ': Different columns'))
        print(setdiff(colnames(xsim), mycols))
        print(setdiff(mycols, colnames(xsim)))
        passcheck=FALSE
    }
    return(passcheck)
}

myMARextinction_sim <- function(genemaps, myscheme, myversion) {
    set.seed(7)
    # TOFIX: only when run interactively in Rmarkdown console, MARextinction_sim outputs waring message
    # no non-missing arguments to min; returning Infno non-missing arguments to max; returning -Inf
    outdt = mar:::MARextinction_sim(genemaps, scheme = myscheme)
    outdt$type = myscheme
    outdt$version = myversion
    return(outdt)
}

compare_extinctionsim <- function(myspecies, myversion) {
    # load genemaps
    load(paste0('./data-raw/tmpobjects/genemaps-', myspecies, '.rda'))
    # load extinction results
    load(paste0('./data-raw/tmpobjects/extinctionsim-', myspecies, '.rda'))
    xsim$version = ogversion # the original output
    xsim = xsim[xsim$type %in% c('random', 'southnorth'),]

    # rerun MARextinction_sim
    randx = myMARextinction_sim(genemaps, 'random', myversion)
    snx = myMARextinction_sim(genemaps, 'southnorth', myversion)

    if(ncol(xsim) != ncol(randx)) {
        warning(paste0(myspecies, 'extinctionsim outdated'))
        message(paste0("colnames(xsim) =", colnames(xsim)))
    }
    output = dplyr::bind_rows(randx, snx, xsim)
    stopifnot(nrow(output) == 320)
    output$id = rep(1:nrow(randx), times = 4) # need this for downstream reshape
    output$species = myspecies
    return(output)
}

plot_output <- function(output) {
    myspecies = unique(output$species)
    plotdt = output %>%
        dplyr::select(-species) %>%
        reshape2::melt(id.vars = c('type', 'version', 'id')) %>%
        tidyr::pivot_wider(names_from = version, values_from = value)

    pp <- ggplot(plotdt, aes_string(x = ogversion, y = myversion, color = "id")) +
        geom_point() +
        geom_abline(slope = 1, intercept = 0) +
        facet_wrap(variable ~ type, scales = 'free', ncol = 2) +
        labs(title = paste(myspecies, myversion)) +
        theme_bw(base_size = 7)
    ggsave(filename = paste0('reproduce_', myspecies, '.pdf'), height = 12, width = 5,
           path = outdir, plot = pp)
    return(pp)
}

# def variables --------
args = commandArgs(trailingOnly=TRUE)
myversion = as.character(args[1])
# myversion = 'v0.0.1'
ogversion = 'MAR1.0'

# output directory
outdir = paste0('data/reproduce_extinctionsim/', myversion)
dir.create(outdir)

# species to test
specieslist = c("acropora","alyrata","amaranthus","arabidopsis","dest","eucalyptus", "joshua","mimulus","mosquito","panicum","panicumhallii","peromyscus","populus","songbird","warbler")

# main --------
# ./tmpobjects/extinctionsim-panicumhallii.rda does not exist
filecheck <- sapply(specieslist, check_file)
table(filecheck)
specieslist = specieslist[filecheck]

# check for column headers
xsimcheck <- sapply(specieslist, check_xsim)
table(xsimcheck)
specieslist = specieslist[xsimcheck]
specieslist

specieslist = 'joshua'
# check all the rest of species n = 9
outdfl <- lapply(specieslist, compare_extinctionsim, myversion = myversion)

# plot the comparison results
plotl <- lapply(outdfl, plot_output)

# output files --------

save.image(paste0(outdir, '/reproduce_extinctionsim.RData'))

# cleanup --------
date()
closeAllConnections()


