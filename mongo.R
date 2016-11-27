library(rmongodb)

matrix.test <- as.data.frame(matrix(rnorm(1000*1000),1000,1000))

matrix <- as.data.frame(matrix)
lst <- split(matrix, 1:nrow(matrix))
df_list <- lapply(lst, mongo.bson.from.list) 

mongo <- mongo.create()     
                                                                    # connect to Mongo on localhost
mongo.is.connected(mongo)
mongo.insert.batch(mongo, ns = "db.covar" , lst = df_list)          # insert into the MongoDB

  
  #dbs <- mongo.get.database.collections(mongo, df_list)
  #print(dbs)
  #mongo.find.all(mongo, "db.test")



