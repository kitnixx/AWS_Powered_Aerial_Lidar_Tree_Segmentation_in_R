arg <- commandArgs(TRUE)

ws <- as.integer(strsplit(arg[1], ",")[[1]])
hmin <- as.integer(strsplit(arg[2], ",")[[1]])

ws
hmin