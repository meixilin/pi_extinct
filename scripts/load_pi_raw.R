library(ggplot2)
library(dplyr)

theme_set(theme_bw())

# plot random extinction from before
dtpath = '/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/mutationarearelationship/mar/tmpobjects/'
plotdir = './plots/pi_raw/'
dir.create(plotdir, recursive = T)
load('/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/mutationarearelationship/mar/tmpobjects/extinctionsim-arabidopsis.rda')
filelist = list.files(path = dtpath,
                      pattern = 'extinctionsim-')
pi_raw()
for (ii in (filelist)) {
    load(paste0(dtpath, ii))
    pp = ggplot(xsim, aes(x = ax, y = pi, color = type)) +
        geom_point() +
        facet_wrap(. ~ type) +
        labs(title = ii)
    ggsave(filename = paste0(ii, '.pi.pdf'), path = plotdir, height = 8, width = 8)
}

# plot random extinction from now
dtpath = './data/extinctionsim-new/'
plotdir = './plots/pi_new/'
dir.create(plotdir, recursive = T)
filelist = list.files(path = dtpath,
                      pattern = 'extinctionsim-new-')

for (ii in (filelist)) {
    load(paste0(dtpath, ii))
    pp = ggplot(xsim, aes(x = ax, y = pi, color = type)) +
        geom_point() +
        facet_wrap(. ~ type) +
        labs(title = ii)
    ggsave(filename = paste0(ii, '.pi.pdf'), path = plotdir, height = 8, width = 8)
}



