# running `MAR_extinction.R`

Sun Apr 21 18:13:04 PDT 2024

```bash
sbatch_species() {
    local SPECIES=${1}
    sbatch --job-name="${SPECIES}" MAR_extinction.sh ${SPECIES}
}

declare -a LSPECIES=(acropora alyrata amaranthus arabidopsis dest eucalyptus joshua mimulus mosquito panicum panicumhallii peromyscus populus songbird warbler)

for SPECIES in ${LSPECIES[@]}; do
    echo $SPECIES
    sleep 2
    sbatch_species $SPECIES
done

# panicumhallii out of memory (job id: 18179332)

# use the -90 suffix and add some leftover species
declare -a LSPECIES=(homosapiens panicumhallii90 rhino torrey wolf)

for SPECIES in ${LSPECIES[@]}; do
    echo $SPECIES
    sleep 2
    sbatch_species $SPECIES
done
```

# running summary script 

```
Rscript --vanilla scripts/extinctionsim_summary.R &> data/extinctionsim_summary/extinctionsim_summary.log
```


