##This script reads in an orthomosaic, deals with NA data, linearises each of the bands and 
##projects to a desired coordinate system.

##Identify suitable dataset e.g. equal shutter speeds and white balance and aperture and ISO

##J.Duffy
##20/01/16

library(raster)
library(rgdal)

rasterOptions(format="GTiff", overwrite=TRUE, tmpdir="C:/R_TEMP")  

setwd("C:/Sandbox/D4_F2_Correct_Classify")
##Name of dataset
dataset <- "D4_F2"
##Coeffs for Canon Powershot D30
coeffs <- read.table("C:/Dropbox/PhD/Kit/Canon_D30/Characterisation/Sunny_WB_1_640_Quadratic_Coeffs.txt")

#############
##FUNCTIONS##
#############

source("C:/Dropbox/PhD/Coding_Projects/Linearisation/Linearisation_Functions.R")

##############
##PROCESSING##
##############

##Ensure that JPEG photos/photos used to create the mosaic are consistent across shutter/apeture/iso/wb
##Apply correct set of white balance coefficients to data i.e. sunny/daylight or cloudy.
##Projection for Greek Grid (EPSG:2100)
greek_proj <- "+init=epsg:2100 +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=0 +datum=GGRS87 +units=m +no_defs +ellps=GRS80 +towgs84=-199.87,74.79,246.62"
##Name of orthomosaic
data <- paste(dataset,"_D_P_M_Crop.tif",sep="")
##Read in orthomosaic
image <- raster(data)
##Split into 3 bands
image.r <- raster(data, band=1)
image.g <- raster(data, band=2)
image.b <- raster(data, band=3)
##Reclass 0 values to NA
image.r <- reclass(image.r,"C:/R_TEMP/temp1.tif",greek_proj)
image.g <- reclass(image.g,"C:/R_TEMP/temp2.tif",greek_proj)
image.b <- reclass(image.b,"C:/R_TEMP/temp3.tif",greek_proj)
##Linearise the 3 bands with the coeffs
image.r.lin <- lin(image.r,coeffs[3,1],coeffs[3,2],coeffs[3,3],"C:/R_TEMP/temp4.tif")
image.g.lin <- lin(image.g,coeffs[2,1],coeffs[2,2],coeffs[2,3],"C:/R_TEMP/temp5.tif")
image.b.lin <- lin(image.b,coeffs[1,1],coeffs[1,2],coeffs[1,3],"C:/R_TEMP/temp6.tif")
##Stack 3 bands together
image.stack <- stack(image.r.lin,image.g.lin,image.b.lin)
##Project the raster (nearest neighbour) - take a while. Also round the data.
image.stack.proj <- round(projectRaster(image.stack,crs=greek_proj,method='ngb'),2)
##Write it
writeRaster(image.stack.proj, paste(dataset,"_D_P_M_Crop_GreekProj_Lin.tif",sep=""))