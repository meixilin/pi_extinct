# data-raw file source and archive record

Last updated: Mon Apr 22 10:40:13 PDT 2024

## download all the tmpobjects

```bash
# 2024-04-05 11:30:46
SOURCE="/home/mlin/safedata/BERKELEY/archive/2022_Exposito-Alonso_mar/mar/tmpobjects"

rsync -ahv mlin@calc.dpb.carnegiescience.edu:${SOURCE} ./
```

## species list

selection criteria:

-   have `genemaps-<species>.rda` file

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

### exceptions (renaming):

renamed `genemaps-panicumhallii-90.rda` to `genemaps-panicumhallii90.rda`. so the delimiter `-` can still work throughout species.

### discarded genemaps files and reasons:

```         
genemaps-panicumhallii.rda  file too large and previous version panicumhallii90 was used
genemaps-panicumhallii-<othersuffix>.rda    subsetted datasets
genemaps-panicumhalii.rda   potential typo for panicumhallii
genemaps-wolf2.rda  the wolf file is already available
genemaps-arabidopsis-<suffix>.rda   not interested in subsetted datasets
```

## the used genemaps md5sum

```         
03bdce1d5a78fbc9868a48bbda16e603  genemaps-acropora.rda
de6f56bd0127d768b998bd1068eb78ab  genemaps-alyrata.rda
0f8b5b31bc19872aa3694bd4b82e4e8e  genemaps-amaranthus.rda
ec14e838f65e730c2eae5c4b975f4b70  genemaps-arabidopsis.rda
eac54c16449e0b23e6bd305d67819b68  genemaps-dest.rda
182ef0390e6b54d4bb25b11550dde2c7  genemaps-eucalyptus.rda
e27db45ecc08b43a8a8880057ed7aeb0  genemaps-homosapiens.rda
ff31c9e1c0a4674dfe9a0bd1ecd897e5  genemaps-joshua.rda
b0f8b57616ffcf5c461175766712aef9  genemaps-mimulus.rda
3c03d6593fa7bdc625ecfcf405abdd4b  genemaps-mosquito.rda
73da9cbf9ca42a8c28a51a034f162950  genemaps-panicum.rda
4919e4d7d7c9934d9840e39b1f243e2b  genemaps-panicumhallii90.rda
fc75f5a47a0446ede113c8d333d17e52  genemaps-peromyscus.rda
9c15f230230ac2fdc4bd908368f9e693  genemaps-populus.rda
bd4e575fc70236b44dcbce2fe389d8a1  genemaps-rhino.rda
c97b86b693dd7730df7800251cec2dbb  genemaps-songbird.rda
28d375aea0dfa5233ace0b07c41b03fb  genemaps-torrey.rda
b210d5e250d43d6cef192af4d7d4c07d  genemaps-warbler.rda
7dba0aa6f15e2485cb63de5bf717fbeb  genemaps-wolf.rda
```
