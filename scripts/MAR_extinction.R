# Title: Rerun the extinction analyses with the updated code
# Author: Meixi Lin
# Date: Thu Dec  1 10:41:38 2022
# Modification: Publication ready version with mar v0.0.3
# Date: Fri Apr 19 16:30:14 2024

# preparation --------
rm(list = ls())
cat("\014")
options(echo = TRUE, stringsAsFactors = FALSE)

require(mar)
require(dplyr)
require(ggplot2)
sessionInfo()
getwd()

theme_set(cowplot::theme_cowplot())

# def functions --------
myMARextinction_sim <- function(genemaps, myscheme, myseed) {
    set.seed(myseed)
    # TOFIX: only when run interactively in Rmarkdown console, MARextinction_sim outputs waring message
    # no non-missing arguments to min; returning Infno non-missing arguments to max; returning -Inf
    outdt = mar:::MARextinction_sim(genemaps, scheme = myscheme)
    # append the last row when A = 0
    outdt
    outdt = outdt %>%
        dplyr::mutate(randomseed = myseed,
                      step = 1:nrow(outdt),
                      a_per = asub/outdt[1, 'asub'],
                      pi_per = pi/outdt[1, 'pi'],
                      thetaw_per = thetaw/outdt[1, 'thetaw'])
    return(outdt)
}

plot_xsim_pi <- function(xsim, myscheme) {
    pp <- ggplot(data = xsim, mapping = aes(x = 1-a_per, y = pi_per, color = as.factor(randomseed))) +
        geom_hline(yintercept = 1, color = 'gray', linetype = 'dotted') +
        geom_line() +
        geom_point(alpha = 0.2) +
        lims(x = c(0,1), y = c(0, max(xsim$pi_per))) +
        labs(x = "% area lost", y = "% theta_pi lost", color = "seed", title = paste0(species, "-", myscheme))
    return(pp)
}

plot_xsim_thetaw <- function(xsim, myscheme) {
    pp <- ggplot(data = xsim, mapping = aes(x = 1-a_per, y = thetaw_per, color = as.factor(randomseed))) +
        geom_hline(yintercept = 1, color = 'gray', linetype = 'dotted') +
        geom_line() +
        geom_point(alpha = 0.2) +
        lims(x = c(0,1), y = c(0, max(xsim$thetaw_per))) +
        labs(x = "% area lost", y = "% theta_w lost", color = "seed", title = paste0(species, "-", myscheme))
    return(pp)
}

basic_plotting <- function(xsim, myscheme) {
    pp1 <- plot_xsim_pi(xsim, myscheme)
    pp2 <- plot_xsim_thetaw(xsim, myscheme)
    ggsave(filename = paste0("xsim-thetapi-", myscheme, "-", species, ".pdf"), path = paste0(outdir, "pdf"), plot = pp1, width = 5, height = 5)
    ggsave(filename = paste0("xsim-thetaw-", myscheme, "-", species, ".pdf"), path = paste0(outdir, "pdf"), plot = pp2, width = 5, height = 5)
    return(list(pp1, pp2))
}

# def variables --------
args = commandArgs(trailingOnly=TRUE)
species = as.character(args[1])

outdir = './data/extinctionsim/'
dir.create(outdir)
dir.create(paste0(outdir, "csv"))
dir.create(paste0(outdir, "pdf"))
dir.create(paste0(outdir, "rda"))
message(paste0(date(), " - Running extinction simulations for ", species))

# set up reproducible seeds
nrep = 20
myseeds = sample(1:1000, nrep)
message(paste0("random seeds used: "))
print(myseeds)

# load data --------
load(paste0('./data-raw/tmpobjects/genemaps-', species, '.rda'))

# main --------
xsim_random <- lapply(myseeds, myMARextinction_sim, genemaps = genemaps, myscheme = "random") %>%
    dplyr::bind_rows()

xsim_southnorth <- lapply(myseeds, myMARextinction_sim, genemaps = genemaps, myscheme = "southnorth") %>%
    dplyr::bind_rows()

# basic plotting --------
plots_random <- basic_plotting(xsim_random, "random")
plots_southnorth <- basic_plotting(xsim_southnorth, "southnorth")

# output files --------
write.csv(xsim_random, file = paste0(outdir, "csv/xsim-random-", species, '.csv'))
write.csv(xsim_southnorth, file = paste0(outdir, "csv/xsim-southnorth-", species, '.csv'))

# cleanup --------
save.image(file = paste0(outdir, "rda/xsim-", species, ".RData"))

message(paste0(date(), "...done"))
closeAllConnections()
