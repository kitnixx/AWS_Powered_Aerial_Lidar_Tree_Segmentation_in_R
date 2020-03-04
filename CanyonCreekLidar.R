# Canyon Creek Snag Segmentation, March 2020
# Kate Nicolato, Alex Feng
# Aerial Information Systems Laboratory, Oregon State University

#==========
# WORKFLOW
#==========

# 1. Compiles area of interest (AOI) point cloud tiles (.las) into a catalog
# 2. Clips catalog to AOI shapefile (.shp)
# 3. Merges the clipped catalog clouds into one cloud (.las)
# 4. Cleans the merged cloud of outlying returns
# 5. Classifies ground returns from canopy returns (ground filter) OR reads in Quantum bare earth DEM and highest hit DEM
# 6. Normalizes classified point cloud (removes terrain/elevation) to create canopy height model (CHM) of true tree heights (.tif, raster)
# 7. Identifies tree tops using local maxima to write out tree point shapefile (.shp, vector)
# 8. Uses algorithm(s) to segment snags/trees - needs specific parameters
# 9. Writes out individual snag/tree polygon shapefile (.shp, vector)

#=================
# Clear workspace
#=================

# Clear plots
if(!is.null(dev.list())) dev.off()

# Clear console
cat("\014") 

# Clean workspace
rm(list=ls())

#==============
# Dependencies 
#==============

install.packages("lidR")
library(lidR)
library(raster)
library(rgdal)

# Run next three lines if you have problems calling EBImage
# install.packages("EBImage")
# install.packages("BiocManager")
# BiocManager::install("EBImage")

library(EBImage)

#=======================
# Set working directory 
#=======================
# Functions: setwd()
# Inputs: Working directory file path
# Outputs: Prints working directory file path

setwd('C:\\Users\\khnic\\Desktop\\test')

# An alternative method to read in files
# file <- system.file("extdata", "megaplot.laz", package="lidR")

# ONLY USE FOR PRE-CLIPPED/MERGED POINT CLOUDS, OTHERWISE START WITH NEXT CODE BLOCK
#=====================================================
# Read in lidar tiles (LAS) for area of interest (AOI) 
#=====================================================
# Functions: readLAS()
# Inputs: A point cloud dataset (.las)
# Ouptuts: None

#las <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8409.las")
#las1 <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8407.las", select ="*+")
#las2 <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8408.las", select ="*+")
#las3 <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8409.las", select ="*+")
#las4 <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8412.las", select ="*+")
#las5 <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8413.las", select ="*+")
#las6 <- readLAS("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8414.las", select ="*+")
# print(las)
# summary(las)
#plot(las)

# START HERE
#=======================
# Read in AOI shapefile 
#=======================
# Functions: readOGR()
# Inputs: AOI shapefile (.shp)
# Outputs: None

aoi <- readOGR(".\\UF_S1D_unit13_obj14_reproj.shp")

#====================================================
# Create LAS tile catalog for area of interest (AOI)
#====================================================
# Functions: readLAScatalog()
# Inputs: A folder of LAS tiles comprising the AOI unit
# Outputs: A catalog of las tiles comprising the AOI unit

ctg <- readLAScatalog("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\44118C8409.las")
lascheck(ctg)
opt_chunk_buffer(ctg) <- 20


#catalog_apply()
#opt_chunk_buffer(ctg)
#opt_chunk_size(ctg)
#opt_chunk_alignment(ctg)
#opt_wall_to_wall(ctg)
#plot(ctg)

#=======================================================
# Clip normalized LAS tiles in catalog to AOI shapefile 
#=======================================================
# Functions: lasclip()
# Inputs:  A normalized, merged catalog of LAS tiles comprising the AOI
# Outputs: A clipped catalog of LAS tiles comprising the AOI

opt_output_files(ctg) <- "unit13_2017_clipped"
las_clip <- lasclip(ctg, aoi)
cleanlas
#writeLAS (las_clip, tempfile(fileext = ".las"))
#plot(las_clip)

# NEEDS WORK
#====================
# Clean point clouds 
#====================
# Functions:
# Inputs:
# Ouptuts:

#============================
# Merge las tiles in catalog 
#============================
# Functions:
# Inputs: A catalog of LAS tiles comprising the AOI
# Outputs: A catalog of merged LAS tiles comprising the AOI
#las_merge <- rbind(las1, las2, las3) # (argument is LAS objects aka each tile name)
#opt_output_files(las_merge) <- (".\\merged_outputs")

# NEEDS WORK
#================================================================
# Ground filter or read in Quantum bare earth & highest hit DEMs 
#================================================================
# Functions: lasground()
# Inputs:
# Outputs: 
# How to use Quantum bare earth and highest hit DEMs instead of making our own??

#?csf
#las_ground <- lasground(las_clip,csf(class_threshold=0.2)) # classify ground points with Cloth Simulation Filter algorithm
#plot(las_ground, color="Classification")

#============
# Create DTM 
#============

#grid_terrain(las, res = 0.5, tin())

#dtm <- grid_terrain(las_clip, 1, RasterLayer())
#las <- lasnormalize(las, dtm)

#plot(dtm)
#plot(las)


#=======================
# Normalize Point Cloud
#=======================
# Functions: lasnormalize()
# Inputs: A catalog of merged LAS tiles comprising the AOI
# Outputs: A normalized catalog of LAS tiles comprising the AOI

opt_output_files(las_clip) <- "unit13_2017_normalized"
las_normal <- lasnormalize(las_clip, tin())

# <- readLAScatalog("unit13_2017_normalized.las")
#lascheck(normal_ctg)
#opt_chunk_buffer(normal_ctg) <- 20
#opt_chunk_size(normal_ctg) <- 0
#opt_output_files(normal_ctg) <- "unit13_2017_buffered"
#buffer_ctg = catalog_retile(normal_ctg)
#lascheck(buffer_ctg)
#writeLAS(las_normal, filename = "unit13_2017_normalized.las", overwite = TRUE)
#opt_output_files(las_normal) <- "C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn\\UpperFawn_normalized"
#plot(las_normal)

#=====================
# Segment Point Cloud 
#=====================
# Functions: lastrees(), lassnags(), dalponte(), silva(), watershed(), wing2015()
# Inputs:
# Outputs:

#==========================
# Canopy Height Model (CHM) 
#==========================
# Functions: grid_canopy()
# Inputs: A segmented catalog of LAS tiles comprising the AOI
# Ouputs: Raster image (.tif) with each pixel displaying a height value (Z)
# How to integrate Forest Service CHMs with Quantum point clouds??

?grid_canopy
chm_dsmtin <- grid_canopy(las_normal, 0.5, dsmtin()) # creates raster for canopy height model (values of cells are z relative to ground)
#chm = grid_canopy(las_normal, 0.5, pitfree())
#chm = grid_canopy(las_normal, 0.5, p2r())
writeRaster(chm, filename= "chm_dsmtin.tif", format = Gtiff, overwrite=TRUE)
#writeRaster(chm, filename= "chm_pitfree.tif", overwrite=TRUE)
#writeRaster(chm, filename= "chm_p2r.tif", overwrite=TRUE)
#writeRaster(chm, "chm.tif", format = "GTiff", overwrite = TRUE)
#raster_alignment = list(res = 0.5)
#raster_alignment
plot(chm, col = height.colors(50)) # displays the chm raster

##########################
# Segment Rasterized CHM #
##########################
# Functions: lastrees(), lassnags(), dalponte(), silva(), watershed(), wing2015()
# Inputs:
# Outputs:

#################
# Cloud Metrics #
#################
# Functions: lasmetrics()
# Inputs:
# Outputs: Tabular file (.xls) with variable statistics for the unit, e.g. mean height, max height, mean density, average returns

###############################################################################
# Write individual tree tops (local maxima) shapefile to output location #
###############################################################################
# Functions: writeOGR()
# Inputs: 
# Outputs: Point shapefile (.shp) of individual snag maximum heights

writeOGR()

###################################################################
# Write individual snag polygon shapefile to output location #
###################################################################
# Functions: writeOGR()
# Inputs:
# Outputs: Polygon shapefile (.shp) of individual snag polygons

writeOGR()

