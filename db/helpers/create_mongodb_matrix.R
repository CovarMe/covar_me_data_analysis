library(rmongodb)
library(foreach)

the.matrix <- read.table('~/Downloads/covar_matrix.txt')
the.dataframe <- as.data.frame(the.image$variance)

df_list <- lapply(lst, mongo.bson.from.list) 

mongo <- mongo.create(host = '52.208.21.118') 
mongo.is.connected(mongo)
n <- nrow(the.matrix)
m <- (n ** 2 + n) / 2
matrix.item.list <- rep(list(i='',j='',v=0,matrix_name=''), m)
t.i <- 1
system.time({
  foreach(i = 1:n) %dopar% {
    for (j in 1:(n + 1 - i)) {
      print(t.i)
      t.i <- t.i + 1
      mi <- mongo.bson.from.list(list(i=colnames(the.matrix)[i],
                                      j=colnames(the.matrix)[j],
                                      v=the.matrix[i,j],
                                      matrix_name='covariance'))
      mil <- list(mi)
      mongo.insert.batch(mongo, ns = "covar_me.matrix_item" , lst = mil)
#     matrix.item.list[[t.i]]['i'] <- colnames(the.matrix)[i]
#     matrix.item.list[[t.i]]['j'] <- colnames(the.matrix)[j]
#     matrix.item.list[[t.i]]['v'] <- the.matrix[i,j]
#     matrix.item.list[[t.i]]['matrix_name'] <- 'covariance'
    }
  }
})

doc.list <- lapply(matrix.item.list, mongo.bson.from.list)



#dbs <- mongo.get.database.collections(mongo, df_list)
#print(dbs)
#mongo.find.all(mongo, "db.test")



