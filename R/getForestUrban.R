#Function to calcualte percentage urban and forest per county in Wisconsin

getForestUrban<- function(countyID,counties,nlcd) {
  
  library(sp)
  library(raster)
  library(rgdal)
  library(rgeos)
  library(dplyr)
  
  county <- subset(counties,counties$OBJECTID==countyID)
  county <-  spTransform(county,crs(nlcd))
  county_nlcd <- crop(nlcd,county)
  
  a <- extract(county_nlcd,county)
  percent_forest = round(100*length(a[[1]][a[[1]]%in% 41:43])/length(a[[1]]),3)
  percent_urban = round(100*length(a[[1]][a[[1]]%in% 21:24])/length(a[[1]]),3)
  
  return(data.frame(percent_forest, percent_urban))
}