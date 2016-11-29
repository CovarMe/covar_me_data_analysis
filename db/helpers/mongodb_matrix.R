library('rmongodb')
library('foreach')
library('doParallel')

# opens a connection to MongoDB and stores 
# all the elements of the matrix individually
# using parralelization to run faster
create.mongodb.matrix <- function(the.matrix, the.host) {
  n <- nrow(the.matrix)
  m <- (n ** 2 + n) / 2
  matrix.item.list <- rep(list(i='',j='',v=0,matrix_name=''), m)
  registerDoParallel(cores = 4)  
  system.time({
#     for (i in 1:n) {
    foreach(i = 1:n,
            .export=c('mongo.create',
                      'mongo.is.connected',
                      'mongo.bson.from.list',
                      'mongo.insert.batch'), 
            .packages='rmongodb') %dopar% {
      batch <- list()
      mongo <- mongo.create(host = the.host) 
      mongo.is.connected(mongo)
      t.j = 1
      for (j in 1:(n + 1 - i)) {
        mi <- mongo.bson.from.list(list(i=colnames(the.matrix)[i],
                                        j=colnames(the.matrix)[j],
                                        v=the.matrix[i,j],
                                        matrix_name='covariance'))
        batch[[t.j]] <- mi
        t.j <- t.j + 1
        if (length(batch) > 2500 || j == (n + 1 - i)) {
          tryCatch({
            mongo.insert.batch(mongo, 
                             ns = "covar_me.matrix_item", 
                             lst = batch)
          }, error = function(e) {
            write(e, 'mongo_matrix.log', append = T)
          })
          print(batch)
          batch <- list()
        }
      }
    }
  })
}
