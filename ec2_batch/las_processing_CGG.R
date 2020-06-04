# Disable warnings
options(warn=-1)

# Clear plots
if(!is.null(dev.list())) dev.off()
# Clear console
cat("\014") 
# Clean workspace
rm(list=ls())

library(rLiDAR) # must put this package above all other packages in order to avoid error - needed for CHMSmoothing
library(lidR)
library(parallel)
library(dplyr)
library(concaveman)
library(rgdal)
library(sp)
library(future)
library(maptools)
#library(EBImage)	# needed to remove this b/c it interferes with watershed algorithm in lidR
library(stringr)
library(rjson)

validInput <- function( param, default ){
  #print(length(unlist(param)) > 0)
  if(length(unlist(param)) > 0)  # true if valid integer
    return(param)
  else
    return(default)
}

arg <- commandArgs(TRUE)
home <- arg[1]
home <- "C:/Users/Alex/Desktop/batch_processing/test-small-file/item/"
#lasName <- arg[2]
lasName <- "plot13_2017.las"
#jsonFile <- fromJSON(file = arg[3])
jsonFile <- fromJSON(file = "C:/Users/Alex/Desktop/batch_processing/ec2_batch/json.json")
outputDir <- paste(home, 'outputs', "/", sep="")

home
outputDir

res <- as.numeric(validInput(jsonFile["res"], 1)) #resolution of DTM and CHM in feet
ws <- as.numeric(validInput(jsonFile["ws"], 10)) #size of moving window in feet
z <- as.numeric(validInput(jsonFile["z"], 10)) #minimum tree height in feet
algorithm <- validInput(jsonFile["algorithm"], "NULL")
if(algorithm == "NULL" || (algorithm != "silva2016" && algorithm != "dalponte2016" && algorithm != "wing2015" && algorithm != "watershed"))
  stop()

res
ws
z
algorithm

# dalponte2016 params
th_tree <- as.numeric(validInput(jsonFile["th_tree"], 2))
th_seed <- as.numeric(validInput(jsonFile["th_seed"], 0.45))
th_cr <- as.numeric(validInput(jsonFile["th_cr"], 0.55))
max_cr <- as.numeric(validInput(jsonFile["max_cr"], 10))

th_tree
th_seed
th_cr
max_cr

# wing2015 params
#neigh_radii <- validInput(jsonFile["neigh_radii"], 2)
low_int_thrsh <- as.numeric(validInput(jsonFile["low_int_thrsh"], 50))
uppr_int_thrsh <- as.numeric(validInput(jsonFile["uppr_int_thrsh"], 170))
pt_den_req <- as.numeric(validInput(jsonFile["pt_den_req"], 3))

#neigh_radii
low_int_thrsh
uppr_int_thrsh
pt_den_req

# watershed params
th_tree <- as.numeric(validInput(jsonFile["th_tree"], 2))
tol <- as.numeric(validInput(jsonFile["tol"], 1))
ext <- as.numeric(validInput(jsonFile["ext"], 1))

th_tree
tol
ext

filter <- validInput(jsonFile["filter"], "mean")
smooth_ws <- as.numeric(validInput(jsonFile["smooth_ws"], 5))
smooth <- as.numeric(validInput(jsonFile["smooth"], 1))

filter
smooth_ws
smooth

#filename for single las tile
lasfile <- paste(home, lasName, sep = "")
print(lasfile)
las <- readLAS(lasfile)

#create output directory 
chmfile <- paste(outputDir,paste(tools::file_path_sans_ext(basename(lasfile))),'_CHM.tif',sep="")
crownfile <- paste(outputDir,paste(tools::file_path_sans_ext(basename(lasfile))),'_crowns',sep="")

#define variables 
cs <- crs(las)#crs of point cloud
p <- util_makeZhangParam()#take parameters from Zhang paper
cores <- detectCores() #how many processor cores are available
plan(multisession, workers = 2L)#set up parallel processing (2L = 2 Clusters)
#Choose one of the following 2 options:
set_lidr_threads(cores/2)#1. for dedicated processing, use all cores
#set_lidr_threads(((cores-2) /2 ))#2. for background processing, reserve 2 cores

ptm <- proc.time()  #START THE CLOCK

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

#define function to detect ground, normalize point cloud, and find treetops
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

print('CHM Smoothing...')
if(smooth == 1){
  CHMsmoothing(chm, filter, smooth_ws)
}

print("Detecting Local Maxima...")
ttops = tree_detection(las_normal, lmf(ws = ws)) #from las file
ttops = subset(ttops, Z >= z )


print("Local Maxima Detection Complete! Segmenting Tree Crowns...")
print(algorithm)
if(algorithm == "silva2016"){
  crowns = lastrees(las_normal, silva2016(chm, ttops)) ##### INSERT USFS R6 CHM ##### 
}
if(algorithm == "dalponte2016"){
  crowns = lastrees(las_normal, dalponte2016(chm,ttops,th_tree = th_tree,th_seed = th_seed,th_cr = th_cr,max_cr = max_cr,ID = "treeID"))
}
if(algorithm == "wing2015"){
  bbpr_thresholds <- matrix(c(0.80, 0.80, 0.70,
                        0.85, 0.85, 0.60,
                        0.80, 0.80, 0.60,
                        0.90, 0.90, 0.55),
                        nrow =3, ncol = 4)

  crowns = lassnags(las_normal, wing2015(neigh_radii = c(1.5, 1, 2),low_int_thrsh = low_int_thrsh,uppr_int_thrsh = uppr_int_thrsh,pt_den_req = pt_den_req,BBPRthrsh_mat = bbpr_thresholds))
}
if(algorithm == "watershed"){
  crowns = lastrees(las_normal, watershed(chm, th_tree = th_tree, tol = tol, ext = ext))
}

# watershed - https://rdrr.io/cran/lidR/man/watershed.html
# wing2015 - https://rdrr.io/cran/lidR/man/wing2015.html
# dalponte2016 - https://rdrr.io/cran/lidR/man/dalponte2016.html

hull_silva <- tree_hulls(crowns, type = "concave", concavity = 1)
print('Tree Crowns Segmented! Preparing Outputs...')
treestats = tree_metrics(crowns, .stdtreemetrics)
treestats = treestats@data
writeRaster(chm, chmfile, overwrite=TRUE)
las.spatial = as.spatial(crowns) #convert to spatial data
las.df=as.data.frame(las.spatial) #convert to data frame
tree.xyz=las.df %>% group_by(treeID) %>% slice(which.max(Z))
treepoints=SpatialPointsDataFrame(tree.xyz[,20:21], tree.xyz)
crs(treepoints) = cs
hull_silva <- merge(hull_silva, tree.xyz, by = 'treeID')
crs(hull_silva) = cs

writeSpatialShape(hull_silva, crownfile) # write shapefile

proc.time() - ptm   #STOP THE CLOCK
