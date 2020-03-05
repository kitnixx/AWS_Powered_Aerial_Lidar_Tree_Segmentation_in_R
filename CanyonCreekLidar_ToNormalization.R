# Canyon Creek Snag Normalization, March 2020
# Kate Nicolato, Alex Feng
# Aerial Information Systems Laboratory, Oregon State University

#==========
# WORKFLOW
#==========

# 1. Compiles area of interest (AOI) point cloud tiles (.las) into a catalog
# 2. Clips catalog to AOI shapefile (.shp) creating output "_clipped.las"
# 3. Normalizes point cloud (removes terrain/elevation) creating output "_normalized.las"

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
# Outputs: Changes working directory to input file path

wd <- setwd('C:\\Users\\khnic\\Desktop\\test')

#============================
# Read in AOI unit shapefile 
#============================
# Functions: readOGR()
# Inputs: AOI shapefile (.shp) file path
# Outputs: Reads in AOI shapefile

aoi <- readOGR(".\\UF_S1D_unit13_obj14_reproj.shp")

#====================================================
# Create LAS tile catalog for area of interest (AOI)
#====================================================
# Functions: readLAScatalog()
# Inputs: A folder of LAS tiles/a single LAS tile comprising the AOI
# Outputs: A catalog of LAS tiles comprising the AOI

ctg <- readLAScatalog("C:\\Users\\khnic\\Desktop\\test\\2017_las_UpperFawn")
lascheck(ctg)
opt_chunk_buffer(ctg)
opt_chunk_size(ctg)
opt_chunk_alignment(ctg)
opt_wall_to_wall(ctg)
plot(ctg)

#========================================
# Clip LAS tile catalog to AOI shapefile 
#========================================
# Functions: lasclip()
# Inputs:  A catalog of LAS tiles comprising the AOI
# Outputs: A clipped catalog of LAS tiles comprising the AOI

opt_output_files(ctg) <- "unit13_2017_clipped"
las_clip <- lasclip(ctg, aoi)
plot(las_clip)

#=======================
# Normalize Point Cloud
#=======================
# Functions: lasnormalize()
# Inputs: A clipped catalog of LAS tiles comprising the AOI
# Outputs: A normalized, clipped catalog of LAS tiles comprising the AOI

opt_output_files(las_clip) <- "unit13_2017_normalized"
las_normal <- lasnormalize(las_clip, tin())
plot(las_normal)
