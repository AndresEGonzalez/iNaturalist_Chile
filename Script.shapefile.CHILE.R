#Script shapefile shp Chile con regiones actualizadas
## Date: Jun-2019

rm(list = ls(all = TRUE))

library(rgdal)
library(maptools)
library(raster)   ## To convert an "Extent" object to a "SpatialPolygons" object.
library(rgeos)

#The shape file data were download from http://www.ide.cl/descargas/capas/subdere/DivisionPoliticaAdministrativa2019.zip
#CHL_adm0.shp -> Country ; CHL_adm1.shp -> Regional; CHL_adm2.shp -> Provincial
shp <- readOGR(dsn = file.path("/home/dell/Documents/1_WORKING/DATA/SHORE_LINE/CHL_adm1.shp"), )

summary(shp)

## Clipping extra area from shp polygon 
CP <- as(extent(-90,-50,-66,-17), "SpatialPolygons")#by bbox 
proj4string(CP) <- CRS(proj4string(shp))

## Clip the map
out <- gIntersection(shp, CP, byid=TRUE)

shp <-out

  
