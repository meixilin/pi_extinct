
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

# after fixing the error in `mar` commits




