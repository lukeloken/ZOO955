# ME<-readOGR(paste0("E:/Git_Repo/ZOO955/Data/Shapefiles"), "Mendota_shape")

CFL<-data.frame(lat=43.0772209,long=(-89.4031414))
coordinates(CFL)<-~long+lat
proj4string(CFL)<-crs(ME)
par(mar=rep(0.5,4))
plot(ME, col='lightblue')
points(CFL, pch=21, col='blue', bg='white',cex=5, lwd=2)
# points(CFL, pch='~', col='blue', cex=2.5, lwd=3)
text(CFL, 'CFL', halo=TRUE, col='blue')
points(CFL, pch=21, col='blue', bg=NA,cex=5, lwd=2)
box(which='plot')
