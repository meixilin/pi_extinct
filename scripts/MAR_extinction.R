# Title: Rerun the extinction analyses with the updated code
# Author: Meixi Lin
# Date: Thu Dec  1 10:41:38 2022

# preparation --------
rm(list = ls())
cat("\014")
options(echo = TRUE, stringsAsFactors = FALSE)

setwd("/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct")
date()
require(mar)
require(dplyr)
sessionInfo()

# def functions --------

# def variables --------
args = commandArgs(trailingOnly=TRUE)
species = as.character(args[1])
outdir = './data/extinctionsim-new/'
dir.create(outdir, recursive = T)
fileextinctionsim = paste0(outdir, 'extinctionsim-new-', species, '.rda')

# load data --------
dtpath = '/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/mutationarearelationship/mar/tmpobjects/'
load(paste0(dtpath, '/genemaps-', species, '.rda'))

# main --------
## extinction##############################################################################
message("in silico extinction of distribution cells ...")
### Simulate extinctions
# random loss of cells in grid
random.X<-
    MARextinction_sim(genemaps,scheme = "random",
                      xfrac=0.01) %>%
    mutate(type='random')
# extinction from outside to
inward.X<-
    MARextinction_sim(genemaps,scheme = "inwards",
                      xfrac=0.01) %>%
    mutate(type='inwards')
# from outside to the midpoint value
inward.X.center<-
    MARextinction_sim(genemaps,scheme = "inwards",
                      centerfun = function(x) (min(x)+max(x))/2) %>%
    mutate(type='inwards.center')
# from south to north
sn.X<-
    MARextinction_sim(genemaps,scheme = "southnorth",
                      xfrac=0.01) %>%
    mutate(type='southnorth')
# radial from a central point
radial.X<-
    MARextinction_sim(genemaps,scheme = "radial",
                      centerfun = median,
                      xfrac=0.05) %>%
    mutate(type='radial')
radial.spain.X<-
    MARextinction_sim(genemaps,scheme = "radial",
                      centerfun = min,
                      xfrac=0.05) %>%
    mutate(type='radial.xymin')
radial.scand.X<-
    MARextinction_sim(genemaps,scheme = "radial",
                      centerfun = max,
                      xfrac=0.05) %>%
    mutate(type='radial.xymax')
# assemble all simulations
xsim<-rbind(random.X,
            inward.X,
            inward.X.center,
            sn.X,
            radial.X,
            radial.spain.X,
            radial.scand.X
)
save(file = fileextinctionsim, xsim)

message("...done")

# output files --------

# cleanup --------
date()
closeAllConnections()
