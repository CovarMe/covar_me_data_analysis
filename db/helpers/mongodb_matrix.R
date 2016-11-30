library('rmongodb')
library('foreach')
library('doParallel')

# opens a connection to MongoDB and stores 
# all the elements of the matrix individually
# using parralelization to run faster
create.mongodb.matrix <- function(the.matrix, the.host) {
  n <- nrow(the.matrix)
  m <- (n ** 2 + n) / 2
  # clear log file
  close(file('mongo_matrix.log', open="w" ))
  # start parrallelism
  registerDoParallel(cores = 4)  
  system.time({
    foreach(i = 1:n,
            .errorhandling = c('pass'),
            .export = c('mongo.create',
                        'mongo.is.connected',
                        'mongo.bson.from.list',
                        'mongo.insert.batch'), 
            .packages='rmongodb') %dopar% {
      batch <- list()
      mongo <- mongo.create(host = the.host) 
      mongo.is.connected(mongo)
      t.j = 1
      for (j in i:n) {
        mi <- mongo.bson.from.list(list(i=colnames(the.matrix)[i],
                                        j=colnames(the.matrix)[j],
                                        v=the.matrix[i,j],
                                        matrix_name='covariance'))
        batch[[t.j]] <- mi
        t.j <- t.j + 1
        if (length(batch) > 500 || j == (n + 1 - i)) {
          mongo.insert.batch(mongo, 
                             ns = "covar_me.matrix_item", 
                             lst = batch)
          batch <- list()
          t.j <- 1
        }
      }
    }
  })
}
