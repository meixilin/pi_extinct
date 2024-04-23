# extinction simulations for MAR2.0

Author: Meixi Lin

Last updated: 2024-04-23 17:31:20

## software versions

* R package `MAR` v0.0.3 for extinctionsim
* R package `MAR` v0.0.3 `ext_debug` branch for tracking southnorth extinction scheme

## important parameters

species tested:

```
acropora
alyrata
amaranthus
arabidopsis
dest
eucalyptus
homosapiens
joshua
mimulus
mosquito
panicum
panicumhallii90
peromyscus
populus
rhino
songbird
torrey
warbler
wolf
```

number of replicates: `20` per species per extinction scheme

extinction schemes explored: `random` and `southnorth` (extinction starts in the north and ends in south)

## important files

In `data/extinctionsim_summary`: 

```
xsim-randomend-19species.csv # combined outputs for 19 species under random extinction scheme. each species has 20 replicates. 
xsim-randomend-19species.pdf # plots for the above csv file
xsim-southnorthend-19species.csv # combined outputs for 19 species under southnorth extinction scheme. each species has 20 replicates. 
xsim-southnorthend-19species.pdf # plots for the above csv file
```

## data structures

```
.
├── README.md
├── data
├── data-raw
└── scripts
```

### In scripts directory: 

* Also available at: https://github.com/meixilin/pi_extinct

```
.
├── install_packages.sh # install mar pacakge
├── MAR_extinction.R # main script for running extinction simulations
├── MAR_extinction.sh # wrapper
├── record_MAR_extinction.md # submission records
├── extinctionsim_summary.R # summarizes MAR_extinction.R output. output files to data/extinctionsim_summary
├── southnorth_track.R # script for debugging the increase in theta_pi in southnorth extinction scheme
└── southnorth_track.sh # wrapper
```

### In data directory:

```
.
├── extinctionsim # outputs by MAR_extinction.R, organized by file types
│   ├── csv
│   ├── logs
│   ├── pdf
│   └── rda
├── extinctionsim_summary # summary results
│   ├── compare_endtheta_acropora.pdf # sanity check for adding endstage theta_pi calculation
│   ├── extinctionsim_summary.RData # R session snapshot
│   ├── extinctionsim_summary.log # logfile
│   ├── xsim-randomend-19species.csv # IMPORTANT OUTPUT
│   ├── xsim-randomend-19species.pdf # IMPORTANT OUTPUT
│   ├── xsim-southnorthend-19species.csv # IMPORTANT OUTPUT
│   └── xsim-southnorthend-19species.pdf # IMPORTANT OUTPUT
└── southnorth_track # outputs by southnorth_track.R, organized by species tested
    ├── arabidopsis
    ├── joshua
    └── logs
```

In `extinctionsim` folder, For example, for the `arabidopsis` species, the following files are generated:

```
├── extinctionsim
│   ├── csv
│   │   ├── xsim-random-arabidopsis.csv
│   │   └── xsim-southnorth-arabidopsis.csv
│   ├── logs
│   │   └── MAR_extinction_arabidopsis.log
│   ├── pdf
│   │   ├── xsim-thetapi-random-arabidopsis.pdf
│   │   ├── xsim-thetapi-southnorth-arabidopsis.pdf
│   │   ├── xsim-thetaw-random-arabidopsis.pdf
│   │   └── xsim-thetaw-southnorth-arabidopsis.pdf
│   └── rda
│       └── xsim-arabidopsis.RData
```

Each southnorth extinction process is plotted in `southnorth_track` folder: 

```
└── southnorth_track
    ├── arabidopsis
    │   ├── xsim-southnorth-arabidopsis-seed200.RData
    │   ├── xsim-southnorth-arabidopsis-seed200.pdf
    │   └── xsim-southnorth-arabidopsis-seed<..> # 19 more replicates
    └── logs
        ├── southnorth_track_arabidopsis_1.log
        └── southnorth_track_arabidopsis_<...>.log # 19 more replicates
```

### In data-raw directory: 

genemaps generated during MAR v0.0.1 is copied and used for simulations: 


```
.
├── README.md
└── tmpobjects
    ├── genemaps-acropora.rda
    ├── genemaps-alyrata.rda
    ├── genemaps-amaranthus.rda
    ├── genemaps-arabidopsis.rda
    ├── genemaps-dest.rda
    ├── genemaps-eucalyptus.rda
    ├── genemaps-homosapiens.rda
    ├── genemaps-joshua.rda
    ├── genemaps-mimulus.rda
    ├── genemaps-mosquito.rda
    ├── genemaps-panicum.rda
    ├── genemaps-panicumhallii90.rda
    ├── genemaps-peromyscus.rda
    ├── genemaps-populus.rda
    ├── genemaps-rhino.rda
    ├── genemaps-songbird.rda
    ├── genemaps-torrey.rda
    ├── genemaps-warbler.rda
    └── genemaps-wolf.rda
```
