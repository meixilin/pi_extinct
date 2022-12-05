# rerun the extinction simulations 

```bash
cd /Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/scripts
# to submit:
sbatch_species() {
    local SPECIES=${1}
    sbatch --job-name="${SPECIES}" MAR_extinction.sh ${SPECIES}
}
joshua 
declare -a LSPECIES=(acropora alyrata amaranthus arabidopsis dest eucalyptus mimulus mosquito panicumhallii panicum peromyscus populus songbird warbler)

for SPECIES in ${LSPECIES[@]}; do
echo $SPECIES
sleep 2
sbatch_species $SPECIES
done 
```
