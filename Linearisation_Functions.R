#############
##FUNCTIONS##
#############

##19/01/16
##J.Duffy

##reclass is a function to reclassify pixels in chunks
##blockSize is a predefined function to give the ideal number of chunks
##for processing a raster in parts. This function deals with each chunk 
##at a time, applying the rules of changing pixel values.
##'out' is an empty raster created with the same extent and resolution 
##as the input. As the chunks are processed, the changed values are
##written into the correct positions in 'out'.
##It turns pixels with 0 values to NA
reclass <- function(x, filename, projection) {
  out <- raster(x)
  bs <- blockSize(out)
  out <- writeStart(out, filename, overwrite=TRUE)
  for (i in 1:bs$n) {
    v <- getValues(x, row=bs$row[i], nrows=bs$nrows[i])
    v[v==0] <- NA
    print(paste(i,"/",length(blockSize(out)$row),sep=""))
    out <- writeValues(out, v, bs$row[i])
  }
  out <- writeStop(out)
  return(out)
}

##Function to linearise each of the band rasters with 3 coefficients for a 2nd order polynomial transformation
lin <- function(x,coeff1,coeff2,coeff3,filename) {
  out <- raster(x)
  bs <- blockSize(out)
  out <- writeStart(out, filename, overwrite=TRUE)
  for (i in 1:bs$n) {
    v <- getValues(x, row=bs$row[i], nrows=bs$nrows[i])
    v <- (coeff1*v)^2+(coeff2*v)+coeff3
    print(paste(i,"/",length(blockSize(out)$row),sep=""))
    out <- writeValues(out, v, bs$row[i])
  }
  out <- writeStop(out)
  return(out)
}