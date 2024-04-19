
# reproduction test

```bash
reinstall_mar() {
    # uninstall mar
    cd /Library/Frameworks/R.framework/Versions/3.6/Resources/library
    rm -r mar
    # reinstall mar
    cd /Users/linmeixi/AMoiLab/mar_related/mar
    ./install
    # check version
    Rscript -e "library(mar); sessionInfo()"
}

run_reprotest() {
    local myver=${1}
    cd /Users/linmeixi/AMoiLab/mar_related/pi_extinct
    Rscript --vanilla scripts/reproduce_extinctionsim.R $myver &> data/reproduce_extinctionsim/reproduce_extinctionsim_${myver}.log
}

# use git = 3c576665cedd871ecf773addca8656110e90d9c2 (Revert R mar to the original release.)
# this git is exactly the same with MAR1.0 release in code base
# also validated using the branch base (derived from 4273d now deleted since the result is confirmed)
reinstall_mar
run_reprotest "v3c576"

# use git = f1696a9db5b83e06549b43fdcb3ef1a92cf7f94e
reinstall_mar
run_reprotest "vf1696"

reinstall_mar
run_reprotest "v68da8"

reinstall_mar
run_reprotest "v9c7c5"

# another 3c576 run
run_reprotest "v11111"
```

| git hash | version name | comparison results | edits |
| ---| --- | ---| ---|
|3c576665cedd871ecf773addca8656110e90d9c2 | v3c576 | same | revert to original |
|f1696a9db5b83e06549b43fdcb3ef1a92cf7f94e | vf1696 | same | small change on `MARextinction_radial` |
|68da83a245fb4352160f51f6a4eba2d0bb2322bb | v68da8 | diff |
|9c7c5342814b542c74f82dbde67004946047f1b0 | v9c7c5 | diff |


Use this function to compare different git commits

```R
compare_gits <- function(myversions) {
    loadSomeRData <- function(vars, file) {
        E <- new.env()
        load(file=file, envir=E)
        return(mget(vars, envir=E, inherits=F))
    }

    outdfs = lapply(myversions, function(myversion) {
        df = loadSomeRData("outdfl", paste0("./data/reproduce_extinctionsim/", myversion, "/reproduce_extinctionsim.RData"))
        df = df[[1]][[1]][,-11]
        return(df)
    })

    # compare with the first one
    for (ii in 2:length(myversions)) {
        message(paste0(myversions[c(1,ii)], collapse = ' vs '))
        print(all.equal(outdfs[[1]], outdfs[[ii]]))
    }
    return(invisible())
}

myversions = c("v0.0.1", "v0.0.2", "v3c576", "vf1696")

compare_gits(myversions)
```

## conclusion: the culprit is the git commit `9c7c53428`

```R
# check if the thetaw is the same after the change in versions
myversions = c("vf1696", "v9c7c5")
outdfs = lapply(myversions, function(myversion) {
    df = loadSomeRData("outdfl", paste0("./data/reproduce_extinctionsim/", myversion, "/reproduce_extinctionsim.RData"))
    df = df[[1]][[1]]
    return(df)
})

filter_df = function(df, mytype) {
    df[df$type == mytype, ]
}

# View(outdfs[[1]])
all.equal(filter_df(outdfs[[1]], 'random')$N, filter_df(outdfs[[2]], 'random')$N) # TRUE
all.equal(filter_df(outdfs[[1]], 'random')$M, filter_df(outdfs[[2]], 'random')$M)

# check 3c576 again
myversions = c("v3c576", "v11111")

outdfs = lapply(myversions, function(myversion) {
        df = loadSomeRData("outdfl", paste0("./data/reproduce_extinctionsim/", myversion, "/reproduce_extinctionsim.RData"))
        df = df[[1]][[1]][,-11]
        return(df)
    })

all.equal(outdfs[[1]], outdfs[[2]])
# TRUE
```

# located the source of descrepancy

through out the extinction process, the same number of samples were used as `rasterN` where actually it should be `N`
by the definitions of $\theta_w$ and $\theta_\pi$

comparing commits 9c7c with 3c57

```
# 9c7c
  if (length(rasterN) == 0) {
    rasterN = N
  }
  # freqs
  P<-fn(apply(values(raster_mutmaps), 2, function(cells) sum(cells>0,na.rm=T) )) / rasterN

# 3c57
P<-fn(apply(values(raster_mutmaps), 2, function(cells) sum(cells>0,na.rm=T) )) / N

```

# for more updates on extinction-sim developments, see `mar` directory

```

```






