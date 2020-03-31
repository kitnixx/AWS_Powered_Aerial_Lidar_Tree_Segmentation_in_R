# Canyon Creek Snag Segmentation, March 2020
# Kate Nicolato, Alex Feng
# Aerial Information Systems Laboratory, Oregon State University

#==========
# WORKFLOW
#==========

# 1. Compiles area of interest (AOI) point cloud tiles (.las) into a catalog
# 2. Clips catalog to AOI shapefile (.shp) creating output "_clipped.las"
# 3. Normalizes point cloud (removes terrain/elevation) creating output "_normalized.las"

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

#=================
# Clear workspace
#=================

# Clear plots
if(!is.null(dev.list())) dev.off()

# Clear console
cat("\014") 

# Clean workspace
rm(list=ls())

#=======================
# Set working directory 
#=======================
# Functions: setwd()
# Inputs: Working directory file path
# Outputs: Changes working directory to input file path

wd <- setwd('C:\\Users\\khnic\\Desktop\\CanyonCreekLidar\\UpperFawn')

#=======================
# Read in AOI shapefile
#=======================
# Functions: readOGR()
# Inputs: AOI shapefile (.shp) file path
# Outputs: Reads in AOI shapefile

#=== Alder Gulch ===

aoi_AG_

#=== Big Canyon ===

aoi_BC_

#=== Crawford Gulch ===

aoi_CG_

#=== Crazy Creek ===

aoi_CC_

#=== East Fork Canyon Creek ===

aoi_EF_

#=== Lower Fawn ===

aoi_LF_

#=== Overholt Creek ===

aoi_OC_

#=== Sloan Gulch ===

aoi_SG_

#=== Upper Fawn ===

aoi_UF_S1A <- readOGR(".\\UF_polys\\UF_S1A_reproj.shp")
aoi_UF_S1B <- readOGR(".\\UF_polys\\UF_S1B_reproj.shp")
aoi_UF_S1C <- readOGR(".\\UF_polys\\UF_S1C_reproj.shp")
aoi_UF_S1D <- readOGR(".\\UF_polys\\UF_S1D_reproj.shp")
aoi_UF_S1E <- readOGR(".\\UF_polys\\UF_S1E_reproj.shp")
aoi_UF_S1F <- readOGR(".\\UF_polys\\UF_S1F_reproj.shp")
aoi_UF <- readOGR(".\\UF_polys\\UF_reproj.shp")

#=== Wall Creek ===

aoi_WC_

#====================================================
# Create LAS tile catalog for area of interest (AOI)
#====================================================
# Functions: readLAScatalog()
# Inputs: A folder of LAS tiles/a single LAS tile comprising the AOI
# Outputs: A catalog of LAS tiles comprising the AOI

#=== Alder Gulch ===

ctg_AG_

#=== Big Canyon ===

ctg_BC_

#=== Crawford Gulch ===

ctg_CG_

#=== Crazy Creek ===

ctg_CC_

#=== East Fork Canyon Creek ===

ctg_EF_

#=== Lower Fawn ===

ctg_LF_

#=== Overholt Creek ===

ctg_OC_

#=== Sloan Gulch ===

ctg_SG_

#=== Upper Fawn ===

ctg_UF_S1A_2016 <- readLAScatalog(".\\UF_las_2016\\UF_S1A_2016_las")
ctg_UF_S1B_2016 <- readLAScatalog(".\\UF_las_2016\\UF_S1B_2016_las")
ctg_UF_S1C_2016 <- readLAScatalog(".\\UF_las_2016\\UF_S1C_2016_las")
ctg_UF_S1D_2016 <- readLAScatalog(".\\UF_las_2016\\UF_S1D_2016_las")
ctg_UF_S1E_2016 <- readLAScatalog(".\\UF_las_2016\\UF_S1E_2016_las")
ctg_UF_S1F_2016 <- readLAScatalog(".\\UF_las_2016\\UF_S1F_2016_las")
ctg_UF_2016 <- readLAScatalog(".\\UF_las_2016\\UF_2016_las")

ctg_UF_S1A_2017 <- readLAScatalog(".\\UF_las_2017\\UF_S1A_2017_las")s
ctg_UF_S1B_2017 <- readLAScatalog(".\\UF_las_2017\\UF_S1B_2017_las")
ctg_UF_S1C_2017 <- readLAScatalog(".\\UF_las_2017\\UF_S1C_2017_las")
ctg_UF_S1D_2017 <- readLAScatalog(".\\UF_las_2017\\UF_S1D_2017_las")
ctg_UF_S1E_2017 <- readLAScatalog(".\\UF_las_2017\\UF_S1E_2017_las")
ctg_UF_S1F_2017 <- readLAScatalog(".\\UF_las_2017\\UF_S1F_2017_las")
ctg_UF_2017 <- readLAScatalog(".\\UF_las_2017\\UF_2017_las")

#=== Wall Creek ===

ctg_WC_

#=== All Units ===

#summary(ctg_)
#lascheck(ctg_)
#opt_chunk_buffer(ctg_)
#opt_chunk_size(ctg_)
#opt_chunk_alignment(ctg_)
#opt_wall_to_wall(ctg_)
plot(ctg_UF_S1A_2016)

#========================================
# Clip LAS tile catalog to AOI shapefile 
#========================================
# Functions: lasclip()
# Inputs:  A catalog of LAS tiles comprising the AOI
# Outputs: A clipped catalog of LAS tiles comprising the AOI

#=== Alder Gulch ===

#=== Big Canyon ===

#=== Crawford Gulch ===

#=== Crazy Creek ===

#=== East Fork Canyon Creek ===

#=== Lower Fawn ===

#=== Overholt Creek ===

#=== Sloan Gulch ===

#=== Upper Fawn ===

opt_output_files(ctg_UF_S1A_2016) <- "UF_S1A_2016_clip"
opt_output_files(ctg_UF_S1B_2016) <- "UF_S1B_2016_clip"
opt_output_files(ctg_UF_S1C_2016) <- "UF_S1C_2016_clip"
opt_output_files(ctg_UF_S1D_2016) <- "UF_S1D_2016_clip"
opt_output_files(ctg_UF_S1E_2016) <- "UF_S1E_2016_clip"
opt_output_files(ctg_UF_S1F_2016) <- "UF_S1F_2016_clip"
opt_output_files(ctg_UF_2016) <- "UF_2016_clip"
lasclip_UF_S1A_2016 <- lasclip(ctg_UF_S1A_2016, aoi_UF_S1A)
lasclip_UF_S1B_2016 <- lasclip(ctg_UF_S1B_2016, aoi_UF_S1B)
lasclip_UF_S1C_2016 <- lasclip(ctg_UF_S1C_2016, aoi_UF_S1C)
lasclip_UF_S1D_2016 <- lasclip(ctg_UF_S1D_2016, aoi_UF_S1D)
lasclip_UF_S1E_2016 <- lasclip(ctg_UF_S1E_2016, aoi_UF_S1E)
lasclip_UF_S1F_2016 <- lasclip(ctg_UF_S1F_2016, aoi_UF_S1F)
lasclip_UF_2016 <- lasclip(ctg_UF_2016, aoi_UF)

opt_output_files(ctg_UF_S1A_2017) <- "UF_S1A_2017_clip"
opt_output_files(ctg_UF_S1B_2017) <- "UF_S1B_2017_clip"
opt_output_files(ctg_UF_S1C_2017) <- "UF_S1C_2017_clip"
opt_output_files(ctg_UF_S1D_2017) <- "UF_S1D_2017_clip"
opt_output_files(ctg_UF_S1E_2017) <- "UF_S1E_2017_clip"
opt_output_files(ctg_UF_S1F_2017) <- "UF_S1F_2017_clip"
opt_output_files(ctg_UF_2017) <- "UF_2017_clip"
lasclip_UF_S1A_2017 <- lasclip(ctg_UF_S1A_2017, aoi_S1A)
lasclip_UF_S1B_2017 <- lasclip(ctg_UF_S1B_2017, aoi_S1B)
lasclip_UF_S1C_2017 <- lasclip(ctg_UF_S1C_2017, aoi_S1C)
lasclip_UF_S1D_2017 <- lasclip(ctg_UF_S1D_2017, aoi_S1D)
lasclip_UF_S1E_2017 <- lasclip(ctg_UF_S1E_2017, aoi_S1E)
lasclip_UF_S1F_2017 <- lasclip(ctg_UF_S1F_2017, aoi_S1F)
lasclip_UF_2017 <- lasclip(ctg_UF_2017, aoi_UF)

plot(lasclip_S1A_2016)

#=======================
# Normalize Point Cloud
#=======================
# Functions: lasnormalize()
# Inputs: A clipped catalog of LAS tiles comprising the AOI
# Outputs: A normalized, clipped catalog of LAS tiles comprising the AOI

opt_output_files(lasclip_UF_S1A_2016) <- "UF_S1A_2016_norm"
opt_output_files(lasclip_UF_S1B_2016) <- "UF_S1B_2016_norm"
opt_output_files(lasclip_UF_S1C_2016) <- "UF_S1C_2016_norm"
opt_output_files(lasclip_UF_S1D_2016) <- "UF_S1D_2016_norm"
opt_output_files(lasclip_UF_S1E_2016) <- "UF_S1E_2016_norm"
opt_output_files(lasclip_UF_S1F_2016) <- "UF_S1F_2016_norm"
opt_output_files(lasclip_UF_2017) <- "UF_2017_norm"
lasnormal_UF_S1A_2016 <- lasnormalize(lasclip_UF_S1A_2016, tin())
lasnormal_UF_S1B_2016 <- lasnormalize(lasclip_UF_S1B_2016, tin())
lasnormal_UF_S1C_2016 <- lasnormalize(lasclip_UF_S1C_2016, tin())
lasnormal_UF_S1D_2016 <- lasnormalize(lasclip_UF_S1D_2016, tin())
lasnormal_UF_S1E_2016 <- lasnormalize(lasclip_UF_S1E_2016, tin())
lasnormal_UF_S1F_2016 <- lasnormalize(lasclip_UF_S1F_2016, tin())
lasnormal_UF_2016 <- lasnormalize(lasclip_UF_2016, tin())

opt_output_files(lasclip_UF_S1A_2017) <- "UF_S1A_2017_norm"
opt_output_files(lasclip_UF_S1B_2017) <- "UF_S1B_2017_norm"
opt_output_files(lasclip_UF_S1C_2017) <- "UF_S1C_2017_norm"
opt_output_files(lasclip_UF_S1D_2017) <- "UF_S1D_2017_norm"
opt_output_files(lasclip_UF_S1E_2017) <- "UF_S1E_2017_norm"
opt_output_files(lasclip_UF_S1F_2017) <- "UF_S1F_2017_norm"
opt_output_files(lasclip_UF_2017) <- "UF_2017_norm"
lasnormal_UF_S1A_2017 <- lasnormalize(lasclip_UF_S1A_2017, tin())
lasnormal_UF_S1B_2017 <- lasnormalize(lasclip_UF_S1B_2017, tin())
lasnormal_UF_S1C_2017 <- lasnormalize(lasclip_UF_S1C_2017, tin())
lasnormal_UF_S1D_2017 <- lasnormalize(lasclip_UF_S1D_2017, tin())
lasnormal_UF_S1E_2017 <- lasnormalize(lasclip_UF_S1E_2017, tin())
lasnormal_UF_S1F_2017 <- lasnormalize(lasclip_UF_S1F_2017, tin())
lasnormal_UF_2017 <- lasnormalize(lasclip_UF_2017, tin())

plot(lasnormal_UF_S1A_2016)

#===========================
# Canopy Height Model (CHM) 
#===========================
# Functions: grid_canopy()
# Inputs: A segmented catalog of LAS tiles comprising the AOI
# Ouputs: Raster image (.tif) with each pixel displaying a height value (Z)

# DSM - DTM
highesthit - bareearth

# Pitfree
chm_pit_UF_S1A_2016 = grid_canopy(lasnormal_UF_S1A_2016, 0.5, pitfree(c(0,2,5,10,15), c(0,1), subcircle = 0.2))
plot(chm_pit_UF_S1A_2016, col = height.colors(50))

# Point to Raster
chm_p2r_UF_S1A_2016 = grid_canopy(lasnormal_UF_S1A_2016, 0.5, p2r(subcircle = 0.2, na.fill = knnidw(k = 10, p = 2)))
plot(chm_p2r_UF_S1A_2016, col = height.colors(50))
# raster::writeRaster(chm,file.path(envrmt$path_data_mof,"mof_chm_one_tile.tif"),overwrite=TRUE)

#opt_output_files(las_normal_1) <- "1A_chm_dsmtin"
#chm_dsmtin_1 <- grid_canopy(las_normal_1, 0.5, dsmtin()) # creates raster for canopy height model (values of cells are z relative to ground)
#chm = grid_canopy(las_normal, 0.5, pitfree())
#chm = grid_canopy(las_normal, 0.5, p2r())

#writeRaster(chm_dsmtin_1, filename= "chm_dsmtin_1.tif", format = Gtiff, overwrite=TRUE)
#writeRaster(chm, filename= "chm_pitfree.tif", overwrite=TRUE)
#writeRaster(chm, filename= "chm_p2r.tif", overwrite=TRUE)
#writeRaster(chm, "chm.tif", format = "GTiff", overwrite = TRUE)
#raster_alignment = list(res = 0.5)
#raster_alignment
#plot(chm_dsmtin_1, col = height.colors(50))
