library(parallel)
library(rmongodb)

cl <- makeCluster(4)
clusterCall(cl, function() { source("create_mongodb_matrix.R") })
stopCluster(cl)
