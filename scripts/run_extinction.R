library(mar)

# load the required objects for
dtpath = '/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/mutationarearelationship/mar/tmpobjects/'
species = 'acropora'
# load(paste0(dtpath, '/mar-', species, '.rda'))
load(paste0(dtpath, '/genemaps-', species, '.rda'))
load(paste0(dtpath, '/extinctionsim-', species, '.rda'))

ysim = MARextinction_in(genemaps, xfrac = 0.2)

# plot the genemaps
plot(genemaps[[1]])
plot(genemaps[[2]]$layer.1)

# define input for mutdiv functions
raster_samples<-genemaps[[1]]
raster_mutmaps<-genemaps[[2]]
rest_mutmaps<-raster_mutmaps

# calculate pi (within mutdiv functions)
# mar::mutdiv --------
require(raster)
# Get the number of samples
# N=sum(fn(values(raster_samples)),na.rm=T)
N=raster::cellStats(raster_samples, 'sum')
# freqs
P<-fn(apply(values(raster_mutmaps), 2, function(cells) sum(cells>0,na.rm=T) )) / N
# at least one cell has to have a presence of a mutation, and sum over
M_<-fn(apply(values(raster_mutmaps), 2, function(cells) any(cells>0)) )
M_[is.na(M_) ]<-0
M<-sum(M_)
# find endemisms
E_<-apply(values(rest_mutmaps), 2, function(cells) any(cells >0))
E_[is.na(E_) ]<-0
table(M_, E_)
E<-sum(M_ & !E_)
# Sum samples across cells
N<-sum(values(raster_samples),na.rm=TRUE)
# Get the number of SNPs for the sample
L<-dim(raster_mutmaps)[3]
# compute diversity, Theta Waterson
if(N>0 & M >0){
    theta<-M/(Hn(N)*L)
    thetapi<-sum(2*P*(1-P),na.rm=T)/L
}else{
    theta=0
    thetapi=0
}
# area taking into account only grid cells with data
# asub= sum(raster_samples[] > 0, na.rm = T) * (res(raster_samples)[1]*res(raster_samples)[2])
asub<-areaofraster(raster_samples)

# area based on simple square
a= dim(raster_samples)[1] * res(raster_samples)[1] * dim(raster_samples)[2] * res(raster_samples)[2]
# return
return(data.frame(thetaw=theta, pi=thetapi,M=M, E=E,N=N,a=a, asub=asub))

