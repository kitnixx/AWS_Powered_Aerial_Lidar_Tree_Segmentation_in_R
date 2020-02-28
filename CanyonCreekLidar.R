# Canyon Creek Snag/Tree Segmentation, March 2020
# Kate Nicolato, Alex Feng
# Aerial Information Systems Laboratory, Oregon State University

#############
# FUNCTIONS #
#############

# 1. Compiles target unit point cloud tiles (.las) into a catalog
# 2. Clips catalog to a shapefile (.shp) area of interest (AOI)
# 3. Merges the clipped catalog clouds into one cloud (.las)
# 4. Cleans the merged cloud of outlying returns
# 5. Classifies ground returns from canopy returns (ground filter) OR reads in Quantum bare earth DEM and highest hit DEM
# 6. Normalizes classified point cloud (removes terrain/elevation) to create canopy height model (CHM) of true tree heights (.tif, raster)
# 7. Identifies tree tops using local maxima to write out tree point shapefile (.shp, vector)
# 8. Uses algorithm(s) to segment snags/trees - needs specific parameters
# 9. Writes out individual snag/tree polygon shapefile (.shp, vector)

#########################
# Set working directory #
#########################

#######################################
# Read in lidar tiles for target unit #
#######################################

###########################################
# Create las tile catalog for target unit #
###########################################
Function: catalog()

#########################
# Read in AOI shapefile #
#########################

#############################
# Clip las tiles in catalog #
#############################
# Functions: lasclip()


##############################
# Merge las tiles in catalog #
##############################
lasmer# Functions:
# Inputs:
# Outputs:

#####################
# Clean point cloud #
#####################
#Functions:

################################################################
# Ground filter or read in Quantum bare earth/highest hit DEMs #
################################################################
# How to use Quantum bare earth and highest hit DEMs instead of making our own?

########################
# Normalize Point Cloud#
########################
# Functions: lasnormalize()
# Inputs:
# Outputs:

#######################
# Segment Point Cloud #
#######################
# Functions: lastrees(), lassnags()
# Inputs:
# Outputs:

# Dalponte: dalponte
# Silva: silva()
# Watershed: watershed()
# Wing2015: wing2015()
# Others from literature

#######################
# Canopy Height Model #
#######################
# Functions: 
# Inputs:
# Ouputs: .tif raster image where each pixel displays a height/elevation value
# How to integrate Forest Service CHMs??

#################
# Rasterize CHM #
#################


##########################
# Segment Rasterized CHM #
##########################
# Functions: lastrees(), lassnags()
# Inputs:
# Outputs:

# Dalponte: dalponte
# Silva: silva()
# Watershed: watershed()
# Wing2015: wing2015()
# Others from literature

#################
# Cloud Metrics #
#################
# Functions: lasmetrics()
# Inputs:
# Outputs: tabular file (.xls) with variable statistics for the unit, e.g. mean height, max height, mean density, average returns

###############################################################################
# Write individual snag/tree tops (Local Maxima) shapefile to output location #
###############################################################################

# Inputs:
# Outputs: point shapefile (.shp) of individual snag/tree maximum heights

###################################################################
# Write individual snag/tree polygon shapefile to output location #
###################################################################

# Inputs:
# Outputs: polygon shapefile (.shp) of individual snag/tree polygons

