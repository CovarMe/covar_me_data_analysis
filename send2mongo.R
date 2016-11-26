library(foreach)
library(doMC)
library(parallel)
library(rjson)

# Installing rmongodb. Download latest package from CRAN at https://cran.r-project.org/src/contrib/Archive/rmongodb/
# Check where your package library is with .libPaths(). Should be [1]
# Make sure zip folder is in your current directory then run 
# install.packages('rmongodb_1.8.0.tar.gz', lib="Library",repos = NULL)

library(rmongodb) 

noCores <- detectCores() - 1
registerDoMC(noCores)


df_list <- parlapply(split(matrix, 1:nrow(matrix)), function(x) mongo.bson.from.JSON(toJSON(x)))

mongo <- mongo.create()                                # connect to Mongo on localhost
if (mongo.is.connected(mongo) == TRUE) {
  icoll <- paste(db, "test", sep=".")
  mongo.insert.batch(mongo, icoll, df_list)          # insert into the MongoDB
  dbs <- mongo.get.database.collections(mongo, db)
  print(dbs)
  mongo.find.all(mongo, icoll)
}

