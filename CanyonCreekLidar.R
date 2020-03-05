library(rjson)
library(lidR)
library(raster)
library(rgdal)
library(EBImage)
library(stringr)

arg <- commandArgs(TRUE)
result <- fromJSON(file = arg[1])


baseDir <- "C:\\Users\\nicolatk\\Desktop\\asdf\\data\\"
wd <- paste(baseDir, result["dir"], "\\", sep = "")
shpFile <- paste(wd, result["shpFile"], sep = "")

#wd <- paste(baseDir, "2017_las_UpperFawn", "\\", sep = "")
#shpFile <- paste(wd, "UF_S1D_unit13_obj14_reproj.shp", sep = "")

aoi <- readOGR(shpFile)
ctg <- readLAScatalog(wd)

lascheck(ctg)
opt_chunk_buffer(ctg)
opt_chunk_size(ctg)
opt_chunk_alignment(ctg)
opt_wall_to_wall(ctg)

outputClippedDir <- paste(str_remove(shpFile, ".shp"), "_clipped", sep = "")
outputClippedDir
opt_output_files(ctg) <- outputClippedDir
las_clip <- lasclip(ctg, aoi)

outputNormalizeDir <- paste(str_remove(shpFile, ".shp"), "_normalized", sep = "")
outputNormalizeDir
opt_output_files(las_clip) <- outputNormalizeDir
las_normal <- lasnormalize(las_clip, tin())
