# extinction simulations for MAR2.0

Author: Meixi Lin

Last updated: 2024-04-19 17:31:20

## software versions

* R package `MAR` v0.0.3

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

extinction schemes explored: `random` and `southnorth`

## data structures

In data directory:

```
.
└── extinctionsim
    ├── csv # csv file outputs
    ├── pdf # basic figures
    └── rda # R session snapshot
```

For example, for the `joshua` species, the following files are generated:

```
.
└── extinctionsim
    ├── csv
    │   ├── xsim-random-joshua.csv
    │   └── xsim-southnorth-joshua.csv
    ├── pdf
    │   ├── xsim-thetapi-random-joshua.pdf
    │   ├── xsim-thetapi-southnorth-joshua.pdf
    │   ├── xsim-thetaw-random-joshua.pdf
    │   └── xsim-thetaw-southnorth-joshua.pdf
    └── rda
        └── xsim-joshua.RData
```
