# Title: Combine all the theta_pi results
# Author: Meixi Lin
# Date: Mon Apr 22 10:07:11 2024

# preparation --------
rm(list = ls())
cat("\014")
options(echo = TRUE, stringsAsFactors = FALSE)

require(mar)
require(dplyr)
require(ggplot2)
require(cowplot)
sessionInfo()
getwd()

theme_set(cowplot::theme_cowplot())

# def functions --------
load_pi_plots <- function(species) {
    myfile = paste0('./data/extinctionsim/rda/xsim-', species, '.RData')
    load(file = myfile)
    ppr = plots_random[[1]]
    pps = plots_southnorth[[1]]
    return(list(ppr, pps))
}

# add the end of extinction theta manually
# the MAR extinction set up does not always end with A = 0 and hard to fix without refactoring
append_endtheta <- function(xsim) {
    xsiml = base::split(xsim, xsim$randomseed)
    xsimll = lapply(xsiml, function(df) {
        yy = df[nrow(df), ] %>%
            dplyr::mutate(thetaw = 0,
                          pi = 0,
                          M = 0,
                          N = 0,
                          asub = 0,
                          ax = 1,
                          mx = 1,
                          step = step+1,
                          a_per = 0, 
                          pi_per = 0,
                          thetaw_per = 0)
        outdf = rbind(df, yy)
        return(outdf)
    })
    outxsim = dplyr::bind_rows(xsimll)
    return(outxsim)
}

# add the endtheta for plots
append_endtheta_pp <- function(pp) {
    outdf = append_endtheta(pp$data)
    pp$data = outdf
    pp = pp + 
        theme(legend.position = "none")
    return(pp)
}

# extract csv 
allspecies_data <- function(pp) {
    outdf = pp$data %>% 
        dplyr::mutate(species_scheme = pp$labels$title)
    rownames(outdf) = NULL
    return(outdf)
}

# def variables --------
# 19 species
specieslist = c("acropora","alyrata","amaranthus","arabidopsis","dest","eucalyptus","joshua","mimulus","mosquito","panicum","panicumhallii90","peromyscus","populus","rhino","songbird","torrey","warbler","wolf")

outdir = './data/extinctionsim_summary/'
dir.create(outdir)

# load data --------
pplist <- lapply(specieslist, load_pi_plots)

pp_randomlist <- lapply(pplist, function(xx) xx[[1]])
pp_southnorthlist <- lapply(pplist, function(xx) xx[[2]])

# main --------
# append the end thetas and remove legends
pp_randomlist_end <- lapply(pp_randomlist, append_endtheta_pp)
pp_southnorthlist_end <- lapply(pp_southnorthlist, append_endtheta_pp)

# check it
pp <- plot_grid(pp_randomlist[[1]], pp_randomlist_end[[1]], align = 'hv', axis = 'tblr')
save_plot(filename = paste0(outdir, "compare_endtheta_acropora.pdf"), plot = pp, base_width = 8)

# plot all species summary --------
pp_random <- plot_grid(plotlist = pp_randomlist_end, align = 'hv', axis = 'tblr', ncol = 4)
save_plot(filename = paste0(outdir, "xsim-randomend-18species.pdf"), plot = pp_random, 
          ncol = 4, nrow = 5, base_height = 4, base_asp = 1)

pp_southnorth <- plot_grid(plotlist = pp_southnorthlist_end, align = 'hv', axis = 'tblr', ncol = 4)
save_plot(filename = paste0(outdir, "xsim-southnorthend-18species.pdf"), plot = pp_southnorth, 
          ncol = 4, nrow = 5, base_height = 4, base_asp = 1)

# output files --------
xsim_randomend = lapply(pp_randomlist_end, allspecies_data) %>% dplyr::bind_rows()
xsim_southnorthend = lapply(pp_southnorthlist_end, allspecies_data) %>% dplyr::bind_rows()

write.csv(xsim_randomend, file = paste0(outdir, "xsim-randomend-18species.csv"))
write.csv(xsim_southnorthend, file = paste0(outdir, "xsim-southnorthend-18species.csv"))

# cleanup --------
save.image(file = paste0(outdir, "extinctionsim_summary.RData"))
message(paste0(date(), "...done"))
closeAllConnections()


