#For preparing lidar data for analysis
#Tailored to Canyon Creek lidar Data for Katharine Nicolato MS project

#cory garms
#13 March 2020

# Clear plots
if(!is.null(dev.list())) dev.off()
# Clear console
cat("\014") 
# Clean workspace
rm(list=ls())

library(lidR)
library(parallel)
library(dplyr)
library(concaveman)
library(rgdal)
library(future)
library(maptools)

#home <- 'C:/Users/Alex/Desktop/batch_processing/data/item/'
#lasName <- 'unit13_2016.las'

arg <- commandArgs(TRUE)
home <- arg[1]
lasName <- arg[2]

outputDir <- paste(home, 'outputs', "/", sep="")
home
outputDir

if(TRUE){

#filename for single las tile
lasfile <- paste(home, lasName, sep = "")
lasfile
las <- readLAS(lasfile)

#create output directory 
chmfile <- paste(outputDir,paste(tools::file_path_sans_ext(basename(lasfile))),'_CHM.tif',sep="")
crownfile <- paste(outputDir,paste(tools::file_path_sans_ext(basename(lasfile))),'_crowns_silva',sep="")

#define variables 
cs <- crs(las)#crs of point cloud
p <- util_makeZhangParam()#take parameters from Zhang paper
cores <- detectCores() #how many processor cores are available
plan(multisession, workers = 2L)#set up parallel processing (2L = 2 Clusters)
#Choose one of the following 2 options:
#set_lidr_threads(cores/2)#1. for dedicated processing, use all cores
set_lidr_threads(((cores-2) /2 ))#2. for background processing, reserve 2 cores

#set parameters
res = 1 #resolution of DTM and CHM in feet
ws = 10 #size of moving window in feet
z = 10 #minimum tree height in feet

#define function to detect ground, normalize point cloud, and find treetops
spitshine.LAS = function(las, chmfile, crownfile, res, ws, z)
{
  print("Starting Ground Point Detection...")
  las <- lasground(las, pmf(p$ws, p$th))#cloth simulation filter 
  print("Ground Point Detection Complete! Starting DTM Creation...")
  dtm = grid_terrain(las, res = res, algorithm = knnidw())
  print("DTM Creation Complete! Starting Normalization...")
  las_normal = lasnormalize(las, dtm) #### INSERT DOGAMI BARE EARTH HERE IF DESIRED. START HERE 
  #### INSTEAD OF AT GROUND POINT DETECTION (LINE 52) ####
  las_normal = lasfilter(las_normal, Z >= 0) #dtmB = grid_terrain(las_pmf, algorithm = tin()))
  print("Normalization Complete! Computing Cloud Statistics...")
  ground <- lasfilter(las_normal, Classification == 2L)
  metrics = cloud_metrics(las_normal, ~myMetrics(X, Y, Z))  # TODO: Want to skip lines 52-60
  print('Point Cloud Statistics: ') 
  print(metrics)
  groundmetrics <- cloud_metrics(ground, ~myMetrics(X, Y, Z))
  print('Ground Statistics: ') 
  print(groundmetrics)
  print('Creating CHM...')
  chm <- grid_canopy(las_normal, res = res, pitfree(c(0,2,5,10,15), c(0, 1.5))) #### INSERT NORMALIZED LAS ####
  print("Detecting Local Maxima...")
  ttops = tree_detection(las_normal, lmf(ws = ws)) #from las file
  ttops = subset(ttops, Z >= z ) 
  print("Local Maxima Detection Complete! Segmenting Tree Crowns...")
  crowns_silva = lastrees(las_normal, silva2016(chm, ttops)) ##### INSERT USFS R6 CHM ##### 
  hull_silva <- tree_hulls(crowns_silva, type = "concave", concavity = 1)
  print('Tree Crowns Segmented! Preparing Outputs...')
  treestats = tree_metrics(crowns_silva, .stdtreemetrics)
  print('1')
  treestats = treestats@data
  print('2')
  writeRaster(chm, chmfile, overwrite=TRUE)
  print('3')
  las.spatial = as.spatial(crowns_silva) #convert to spatial data
  print('4')
  las.df=as.data.frame(las.spatial) #convert to data frame
  print('5')
  tree.xyz=las.df %>% group_by(treeID) %>% slice(which.max(Z))
  print('6')
  treepoints=SpatialPointsDataFrame(tree.xyz[,20:21], tree.xyz)
  print('7')
  crs(treepoints) = cs
  print('8')
  hull_silva <- merge(hull_silva, tree.xyz, by = 'treeID')
  print('9')
  crs(hull_silva) = cs
  print('10')
  #writeOGR(hull_silva, home, crownfile, driver="ESRI Shapefile", overwrite_layer=TRUE)
  
  #currdir <- getwd() #store your current working directory
  #print('11')
  #setwd("C:/Users/Alex/Desktop/asdf/lidartest/vectors/") #switch to your desired folder
  #print('12')
  writeSpatialShape(hull_silva, crownfile) # write shapefile
  #print('13')
  #setwd(currdir) #switch back to parent folder
  
  return(las_normal)
}

myMetrics = function(x, y, z)
{
  metrics = list(
    zmax = max(z), # Mean elevation weighted by intensities
    z90  = quantile(z, .9),       # Mean products of z by intensity
    z95 =quantile(z, .95) ,  # Quadratic mean
    points = length(z),
    area =  (max(x) - min(x)) * (max(y) - min(y)), 
    density = (length(z)) / ((max(x) - min(x)) * (max(y) - min(y)))
    # mean intensity?? (see cloud_metrics documentation for example)
  )
  
  return(metrics)
}


ptm <- proc.time()#START THE CLOCK
spitshine.LAS(las, chmfile, crownfile, res, ws, z)
proc.time() - ptm#STOP THE CLOCK


# ptm <- proc.time()#START THE CLOCK
# 
# for (i in LASlist) {
#   lasfile <- (i)
#   stemdetection.LAS(readLAS(lasfile), vox, dens, n, rad)
#   }
# proc.time() - ptm#STOP THE CLOCK


# plot(las, color = "Classification")

# Plot CHM
#plot(chm, xlab = "", ylab = "", xaxt='n', yaxt = 'n')
# Add dominant treetops to the plot
#plot(ttops_sub, col = "blue", pch = 20, cex = 0.5, add = TRUE)
}

