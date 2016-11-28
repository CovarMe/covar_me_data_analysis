library(rmongodb)
library(foreach)

# opens a connection to MongoDB and stores 
# all the elements of the matrix individually
# using parralelization to run faster
create.mongodb.matrix <- function(the.matrix, the.host) {
  mongo <- mongo.create(host = the.host) 
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
        mongo.insert.batch(mongo, 
                           ns = "covar_me.matrix_item", 
                           lst = list(mi))
      }
    }
  })
}
