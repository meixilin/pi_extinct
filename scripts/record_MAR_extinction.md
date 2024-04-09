# rerun the extinction simulations

```bash
# 2022-12-01
cd /Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/scripts
# to submit:
sbatch_species() {
    local SPECIES=${1}
    sbatch --job-name="${SPECIES}" MAR_extinction.sh ${SPECIES}
}
sbatch_species 'joshua' # this log was lost
declare -a LSPECIES=(acropora alyrata amaranthus arabidopsis dest eucalyptus mimulus mosquito panicumhallii panicum peromyscus populus songbird warbler)

for SPECIES in ${LSPECIES[@]}; do
echo $SPECIES
sleep 2
sbatch_species $SPECIES
done
```

# run the extinction simulations keeping the N constant

```bash
# 2023-03-13
cd /Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/scripts
# to submit:
sbatch_species() {
    local SPECIES=${1}
    sbatch --job-name="${SPECIES}" MAR_extinction.sh ${SPECIES}
}

sbatch_species 'joshua' # 178742

declare -a LSPECIES=(acropora alyrata amaranthus arabidopsis dest eucalyptus mimulus mosquito panicumhallii panicum peromyscus populus songbird warbler)

for SPECIES in ${LSPECIES[@]}; do
echo $SPECIES
sleep 2
sbatch_species $SPECIES
done
```




