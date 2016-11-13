library(foreach)
library(doMC)
library(parallel)
library(dplyr)
library(data.table)
library(httr)
library(xml2)
library (plyr)
library(zoo)
require(lubridate)


## Compute best shrinkaged covariance matrix function
## Ricorda inizio fine parameters
compute_cov <- function(data,returns, alpha){
  
  #initial <- as.Date(strptime(min(returns$date), "%Y-%m-%d"))
  #end     <- as.Date(strptime(max(returns$date), "%Y-%m-%d"))
  
  
  ## To select the window we only need to select it from returns
 # returns <- filter(returns, date > initial & date < end)
  
  
  listofreturns <- foreach(n = companynames  , .combine = append, .init=list()) %dopar% {
    ## Pick only companies who shows the same day we selected
    if(all(returns$date %in% data[data$COMNAM == n,]$date)){
      list(list(name=as.character(n),return= data[data$COMNAM == n,]$RET,date =as.character(data[data$COMNAM == n,]$date)))}
  }
  
  ## Match regressions by dates
  estimates  <- foreach(n = 1:length(listofreturns), .combine = append, .init = list()) %dopar%{
    returnmatrix <- as.data.frame(cbind(listofreturns[[n]]$return, as.character(listofreturns[[n]]$date)))
    returnmatrix$V1 <- as.numeric(as.character(returnmatrix$V1))
    colnames(returnmatrix) <- c("stockreturn", "date" )
    returnmatrix$date <- as.character(returnmatrix$date)
    ## Get the vector of returns matching the date of our vector
    X <- returns[as.character(returns$date) %in% returnmatrix$date,]
    X <- X[!duplicated(X$date),]
    X$date <- as.character(X$date)
    returnmatrix <- returnmatrix[returnmatrix$date %in% X$date,]
    dd <- merge(returnmatrix, X, by="date")
    reg <- lm(stockreturn~I(mkt_return - rf), data=dd)
    b1 <- coef(reg)[2]
    epselon <- na.omit(dd$stockreturn) - predict(reg)
    residual_var <- var(epselon)
    ## Keep track also of the company 
    list(b1,residual_var, listofreturns[[n]]$name)
  }
  
  
  ## Biased variance estimator:
  names <- unlist(estimates[seq(from=3,to=length(estimates), by=3)])
  betas <- matrix(estimates[seq(from=1,to=length(estimates), by=3)])
  betas <- as.numeric(as.character(betas))
  mkt_variance <- var(returns$mkt_return)
  res_var <- matrix(estimates[seq(from=2,to=length(estimates), by=3)])
  res_var <- as.numeric(as.character(res_var))
  ## Drop all useless staff

  
  ## filter the companies with our names
  data2 <-  filter(data, COMNAM %in% names)
  
  ## filter the data with dates in mktreturn dates
  data2 <- filter(data, date %in% returns$date)
  ## S: sample covariance, Phi is the prior, alpha is the shrinkage paramete
  
  
  X <- foreach(n = names, .combine = function(x,y)(merge(x,y,by="date")), .init=returns) %dopar% {
    filtered <- filter(data2, COMNAM == n)
    filtered <- filter(filtered, date %in% returns$date)
    filtered <- filtered[!duplicated(filtered$date),]
    xx <- data.frame(cbind(filtered$RET,date =filtered$date))
    names(xx) <- c(as.character(n), "date")
    xx }
  X <- X[,names]
  X <- apply(X,2,as.numeric)
  ## Interpolate missing column values using spline approximation
  X <- apply(X,2, na.spline)

  
  
  S <- t(X)%*%X
  Phi <- mkt_variance*(betas%*%t(betas)) + diag(res_var)
  
  Sigma <- alpha*S + alpha*Phi
  diagonalization <- eigen(Sigma,TRUE)
  Q <- unlist(diagonalization[[2]])
  
  ## Store A
  ## Invert using the spectral decomposition
  Precision <- t(Q)%*%diag(1/unlist(diagonalization[[1]]))%*%Q 
  rm(Q)
  ## Compute weightsù
  mu <- apply(X, 2, mean)
  target_ret <- 0.001
  A <- t(rep(1, dim(Precision)[1]))%*%Precision%*%rep(1, dim(Precision)[1])
  B <- t(rep(1, dim(Precision)[1]))%*%Precision%*%mu
  C <- t(mu)%*%Precision%*%mu
  weight <- as.numeric((C - target_ret*B)/(A*C- B^2))*(Precision%*%rep(1,dim(Precision)[1])) + 
    as.numeric((target_ret*A-B)/(A*C - B^2))*Precision%*%mu
  port_var <- t(weight)%*%Sigma%*%weight
  
  return(list(Sigma=Sigma,Precision = Precision,weights = weight,tot_var = port_var,names = names))
  
}



## Find alpha with cross validation: 


cross_validate <- function(data, returns, train_period, alpha){
  sequence <- seq(from=min(returns$date),to=max(returns$date), by="month")
  ## Drop the first periods module of the train period
  sequence <- sequence[-c(1:(length(sequence)%%(train_period + 1)))]
  mspe <- foreach(i=seq(from=1,to=(length(sequence) - train_period), by=(train_period+1)), .combine=append,.init=list()) %dopar% {
    rr <- returns[returns$date >= sequence[i] & returns$date <= sequence[i+train_period - 1],]
    ## Pick the minimum variance matrix but first drop observations disappeared the following month
    train <- data[data$date >= sequence[i] & data$date <= sequence[i+train_period - 1],]
    test  <- data[data$date <= sequence[i+train_period] & data$date > sequence[i+train_period - 1],]
    train <- train[train$COMNAM %in% test$COMNAM,]
    values <- compute_cov(data = train, rr, alpha)[c(3,4,5)]
    test <- test[test$COMNAM %in% values$names,]
    test_ret <- foreach(j=seq(1:length(values$weights)), .combine=function(x,y)(full_join(x,y,by="date"))) %do%{
      filtered <- filter(test, COMNAM == values$names[j])
      dates <- filtered$date
      ## Avoid Duplicated observations: same date, same company -> problem of dataset
      filtered <- filtered[!duplicated(filtered$date),]
      ## Keep track of shares with less days then others and cut non conformable days -> problem of dataset
      filtered <- filtered[filtered$date %in% dates,]
      cat(paste0(as.character(length(filtered$date)), " "))
      filtered$RET <- na.approx(filtered$RET)
      data_frame <- as.data.frame(cbind(date = as.character(filtered$date), as.character(filtered$RET)))
    }
    test_ret <- na.omit(test_ret)
    test_ret <- apply(test_ret[,-1],2,as.numeric)
    var <- var(as.vector(t(values$weights)%*%t(test_ret)))
    list(out_of_sample = var, in_sample = values$tot_var)
    cat(as.character(i), " ", as.character(dim(test_ret)[2]), " ", as.character(length(values$weights)), " ")
    }
  
}
  