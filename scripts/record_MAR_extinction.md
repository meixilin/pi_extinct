# rerun the extinction simulations 

```bash
cd /Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/scripts
# to submit:
sbatch_species() {
    local SPECIES=${1}
    sbatch --job-name="${SPECIES}" MAR_extinction.sh ${SPECIES}
}

declare -a LSPECIES=(acropora alyrata amaranthus arabidopsis dest eucalyptus joshua mimulus mosquito panicumhallii panicum peromyscus populus songbird warbler)

for SPECIES in ${LSPECIES[@]}; do
echo $SPECIES
sbatch_species $SPECIES
done 
```
