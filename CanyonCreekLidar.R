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

# las <- readLAS(".\\plot13_2017.las", select ="*+")
# print(las)
# summary(las)
# plot(las)

# START HERE
#=======================
# Read in AOI shapefile 
#=======================
# Functions: readOGR()
# Inputs: AOI shapefile (.shp)
# Outputs: None

aoi <- readOGR(".\\UF_S1D_unit13_obj14.shp")

#====================================================
# Create LAS tile catalog for area of interest (AOI)
#====================================================
# Functions: readLAScatalog()
# Inputs: A folder of LAS tiles comprising the AOI unit
# Outputs: A catalog of las tiles comprising the AOI unit

ctg <- readLAScatalog(".\\2017_las_UpperFawn")
plot(ctg)

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

las_merge <- rbind.LAS() # (argument is LAS objects aka each tile name)
opt_output_files(ctg) <- "folder/where/to/store/outputs/{ORIGINALFILENAME}_merged"

# NEEDS WORK
#================================================================
# Ground filter or read in Quantum bare earth & highest hit DEMs 
#================================================================
# Functions: lasground()
# Inputs:
# Outputs: 
# How to use Quantum bare earth and highest hit DEMs instead of making our own??

#?csf
#las_ground <- lasground(ctg,csf(class_threshold=0.2)) # classify ground points with Cloth Simulation Filter algorithm
#plot(las_ground, color="Classification")

#=======================
# Normalize Point Cloud
#=======================
# Functions: lasnormalize()
# Inputs: A catalog of merged LAS tiles comprising the AOI
# Outputs: A normalized catalog of LAS tiles comprising the AOI

las_normal <- lasnormalize() # (las_ground, tin())
opt_output_files(ctg) <- "folder/where/to/store/outputs/{ORIGINALFILENAME}_normalized"
plot(las_normal)

#=======================================================
# Clip normalized LAS tiles in catalog to AOI shapefile 
#=======================================================
# Functions: lasclip()
# Inputs:  A normalized, merged catalog of LAS tiles comprising the AOI
# Outputs: A clipped catalog of LAS tiles comprising the AOI

las_clip <- lasclip(ctg, aoi)
opt_output_files(ctg) <- "folder/where/to/store/outputs/{ORIGINALFILENAME}_clipped"
plot(las_clip)

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
chm = grid_canopy(las_normal_clip, 0.045, dsmtin()) # creates raster for canopy height model (values of cells are z relative to ground)
plot(chm, col = height.colors(50)) # displays the chm raster
writeRaster(chm, filename= "chm.tif", overwrite=TRUE)


#################
# Rasterize CHM #
#################



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
