
# Code to generate a table of percent urban/forest by county
# starting directory is project directory
# setwd("E:/Git_Repo/ZOO955")

library(sp)
library(raster)
library(rgdal)
library(rgeos)
library(dplyr)

source('R/getForestUrban.R')

#load data
nlcd <- raster("Data/Rasters/nlcd_2011_landcover_2011_edition_2014_10_10/nlcd_2011_landcover_2011_edition_2014_10_10.img", package='raster')

counties <- readOGR('Data/Shapefiles/County_Boundaries_24K.shp', layer='County_Boundaries_24K',stringsAsFactors = F)
counties <- spTransform(counties,  crs(nlcd))

states <-  readOGR("Data/Shapefiles",  'StateOutlines')
states <- spTransform(states,  crs(nlcd))
WI <- states[states$NAME=='Wisconsin',]

# Crop nlcd to state of Wisconsin
nlcdWI <- crop(nlcd,counties)

# Save WI nlcd to use for plotting and other analyses. 
saveRDS(nlcdWI, "outputs/WIcroppedNLC.rds")


# ###########################################################
# Run through all counties and calculate percent forest/urban
# ###########################################################

# Create vector that will be used in the apply parallel call
c = counties$OBJECTID

# Test to see if function works on Dane County (objectid==12)
d<-c[12]
perDane<-getForestUrban(d,counties,nlcdWI)
plot(subset(counties, counties$OBJECTID==d))
plot(nlcdWI, add=T)
plot(subset(counties, counties$OBJECTID==d), add=T, lwd=4)


#### RUN IN PARALLEL ####
library(parallel)
# Calculate the number of cores
no_cores <- detectCores() - 1
# Initiate cluster
cl <- makeCluster(no_cores)

# Call function
outputForestUrban = parLapply(cl, c, getForestUrban, counties = counties, nlcd = nlcdWI)

# Stop cluster
stopCluster(cl)

# Write output
pfu <- data.frame(counties = counties$COUNTY_NAM, ldply(outputForestUrban))
write.csv(pfu,'outputs/WIforesturban_NLCD.csv',row.names = F)

