# data-raw file source and archive record

Source file: 

```bash
safedata="/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone"
expired_mar="${safedata}/mutationarearelationship"
current_mar="${safedata}/BERKELEY/archive/2022_Exposito-Alonso_mar"
```

Previously, genemaps have been copied: 

```R
dtpath = '/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/mutationarearelationship/mar/tmpobjects/'
genemapfile = paste0(dtpath, '/genemaps-', species, '.rda')
load(genemapfile)
# copy the files just in case
file.copy(genemapfile, '/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/data-raw/genemaps/')
```

Copy some files to local for testing: 

```bash
cd /home/mlin/safedata/meixilin/pi_extinct/data-raw

rsync -ahv ${current_mar}/mar/tmpobjects/extinctionsim-*.rda extinctionsim/
```

# final files

```
49397578f7aa67b49b992a40e32d8bec  extinctionsim-acropora.rda
7e7acc3674df7cbe5ea8f5aacd49e060  extinctionsim-alyrata.rda
e480e52c1d3243ea704ac079eb89d7b2  extinctionsim-amaranthus.rda
fd5f79e6ecb5b13f688d6d2cac393cfa  extinctionsim-arabidopsis.rda
8a0f2feb921f5ef87cd746a4e6e88f0f  extinctionsim-dest.rda
5c90e4bf500e4b50435935cec57cca67  extinctionsim-eucalyptus.rda
a5b618938ae18a436a47c45dcfba1c5c  extinctionsim-joshua.rda
ffad7efba9b7ca8b99a52885b96ce72d  extinctionsim-mimulus.rda
393d5019fa492579a3fdea2b9d0a621e  extinctionsim-mosquito.rda
3cedc622f4325f65da1e5fe0adf9ec39  extinctionsim-panicumhallii-90.rda
209781fbc7304765bf5f5fb22de7933d  extinctionsim-panicum.rda
82829a2e4a9e91d736b66cf635ed01d3  extinctionsim-peromyscus.rda
ff7992d1fd52738e85476b182d6b4900  extinctionsim-populus.rda
27771f44cb58ae6f9b5d242f0e7a8f24  extinctionsim-songbird.rda
7726dc06db5150f7f9a45a142241cbfe  extinctionsim-warbler.rda
```

genemaps: 

```
03bdce1d5a78fbc9868a48bbda16e603  genemaps-acropora.rda
de6f56bd0127d768b998bd1068eb78ab  genemaps-alyrata.rda
0f8b5b31bc19872aa3694bd4b82e4e8e  genemaps-amaranthus.rda
ec14e838f65e730c2eae5c4b975f4b70  genemaps-arabidopsis.rda
eac54c16449e0b23e6bd305d67819b68  genemaps-dest.rda
182ef0390e6b54d4bb25b11550dde2c7  genemaps-eucalyptus.rda
ff31c9e1c0a4674dfe9a0bd1ecd897e5  genemaps-joshua.rda
b0f8b57616ffcf5c461175766712aef9  genemaps-mimulus.rda
3c03d6593fa7bdc625ecfcf405abdd4b  genemaps-mosquito.rda
44fc6f44163a8f8bb96ba537c31bace7  genemaps-panicumhallii.rda
73da9cbf9ca42a8c28a51a034f162950  genemaps-panicum.rda
fc75f5a47a0446ede113c8d333d17e52  genemaps-peromyscus.rda
9c15f230230ac2fdc4bd908368f9e693  genemaps-populus.rda
c97b86b693dd7730df7800251cec2dbb  genemaps-songbird.rda
b210d5e250d43d6cef192af4d7d4c07d  genemaps-warbler.rda
```





