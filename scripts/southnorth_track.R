# Title: Track extinction process for arabidopsis
# Author: Meixi Lin
# Date: Mon Apr 22 14:04:02 2024

# preparation --------
rm(list = ls())
cat("\014")
options(echo = TRUE, stringsAsFactors = FALSE)

library(dplyr)
library(raster)

setwd("/global/scratch/projects/fc_moilab/meixilin/pi_extinct")

# load all mar scripts at ext_debug branch
# DO NOT USE library(mar)
devtools::load_all("../mar")
MARextinction_sn

# def functions --------
loadSomeRData <- function(vars, file) {
    E <- new.env()
    load(file=file, envir=E)
    return(mget(vars, envir=E, inherits=F))
}

plot_extinction <- function(raster_samples, toextinct, pires, thetapi_1l, thetapi_2l) {
    # plot1: raster sample maps
    plot(raster_samples)
    if (!is.null(toextinct)) {
        for (ii in toextinct) {
            rc <- rowColFromCell(raster_samples, ii)
            plot(extent(raster_samples, rc[1], rc[1], rc[2],  rc[2]), add=TRUE, col='red')
        }
    }
    # plot2: distribution of P
    graphics::hist(pires[[1]], xlab = "P", main = "")
    abline(v = mean(pires[[1]]), col = 'lightblue')
    abline(v = median(pires[[1]]), col = 'pink')
    # plot3: theta_pi changes
    plot(thetapi_1l, ylab = "N/(N-1)", ylim=c(1,2))
    # plot4: 2pq changes
    plot(thetapi_2l, ylab = "sum(2PQ)/L", ylim=c(thetapi_2l[1]*0.5,thetapi_2l[1]*1.5))
    abline(h = thetapi_2l[1], col = 'lightblue')
    # plot5: theta_pi percentage
    thetapi_l = thetapi_1l * thetapi_2l
    thetapi_lper = thetapi_l/thetapi_l[1]
    plot(thetapi_lper, ylab = "% thetapi", ylim=c(0.5,1.5))
    abline(h = 1, col = 'lightblue')
    return(invisible())
}

calc_pi <- function(raster_samples, raster_mutmaps, refmut) {
    N = cellStats(raster_samples, "sum")
    mutsum = cellStats(raster_mutmaps, "sum")
    P = mutsum/N
    M = sum(mutsum > 0)
    L <- dim(raster_mutmaps)[3]
    if (N > 1 & M > 0) {
        theta <- M / (Hn(N-1) * L)
        thetapi_1 <- (N/(N-1))
        thetapi_2 <- sum(2 * P * (1 - P), na.rm = T) / L
        thetapi <- thetapi_1 * thetapi_2
    } else {
        theta <- 0
        thetapi <- 0
        thetapi_1 <- NA
        thetapi_2 <- NA
    }
    # check with original calculations
    stopifnot(all.equal(refmut$thetaw, theta))
    stopifnot(all.equal(refmut$pi, thetapi))
    stopifnot(all.equal(refmut$M, M))
    stopifnot(all.equal(refmut$N, N))

    # return the two components of thetapi calculations
    return(list(P, thetapi_1, thetapi_2))
}

# def variables --------
args = commandArgs(trailingOnly=TRUE)
species = as.character(args[1])
repid = as.integer(args[2])

outdir = paste0('./data/southnorth_track/', species, '/')
dir.create(outdir)

# load data --------
prevdata = loadSomeRData(c("xsim_southnorth", "genemaps", "myseeds"), 
                         paste0("./data/extinctionsim/rda/xsim-", species, ".RData"))
xsim_southnorth = prevdata[[1]]; genemaps = prevdata[[2]]; myseeds = prevdata[[3]]




# main --------
# rerun the southnorth extinction with the new debug option
myseed = myseeds[repid] # use the given replicate id
set.seed(myseed)
xsim_debug = MARextinction_sim(genemaps, scheme = "southnorth", debug = TRUE)
listext = xsim_debug[[2]]
listext = c(listext, list(NULL))

# use this replicate id (randomseed)'s xsim_southnorth 
xsim_southnorth = xsim_southnorth[xsim_southnorth$randomseed == myseed, ]


# plot the process of extinction with the info from listext ========
raster_samples <- genemaps[[1]]
raster_mutmaps <- genemaps[[2]]

# keep thetapi_1 and thetapi_2 lists
thetapi_1l = rep(NA, times = length(listext))
thetapi_2l = rep(NA, times = length(listext))

pdf(file = paste0(outdir, 'xsim-southnorth-', species, '-seed', myseed, '.pdf'), width = 8, height = 12, onefile = TRUE)
pp <- par(mfrow = c(10,5), cex.axis = 0.5, cex.lab = 0.5, mar=c(2,2,2,2))
for (ii in 1:length(listext)) {
    toextinct = listext[[ii]]
    # check pi calculation is consistent with previous run without debug
    # at ii=1 step, the results before extinction is plotted. 
    # at ii=2, result after the first extinction is plotted ... 
    pires = calc_pi(raster_samples, raster_mutmaps, refmut = xsim_southnorth[ii, ])
    thetapi_1l[ii] = pires[[2]]; thetapi_2l[ii] = pires[[3]]
    plot_extinction(raster_samples, toextinct, pires, thetapi_1l, thetapi_2l)
    if (ii %% 10 == 0) {
        par(pp)
        pp <- par(mfrow = c(10,5), cex.axis = 0.5, cex.lab = 0.5, mar=c(2,2,2,2))
    }
    # perform extinction
    if (!is.null(toextinct)) {
        values(raster_samples)[toextinct] <- NA
        values(raster_mutmaps)[toextinct, ] <- NA
    }
}
dev.off()

# output files --------
# save session 
save.image(file = paste0(outdir, 'xsim-southnorth-', species, '-seed', myseed, '.RData'))

# cleanup --------
date()
# close devices 
while (!is.null(dev.list()))  dev.off()
closeAllConnections()

