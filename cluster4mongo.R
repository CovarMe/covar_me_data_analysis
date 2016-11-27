library(parallel)
library(rmongodb)

cl <- makeCluster(4)
clusterCall(cl, function() { source("mongo.R") })

## do some parallel work

stopCluster(cl)
