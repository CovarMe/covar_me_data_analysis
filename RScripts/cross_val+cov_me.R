## Script with functions : to load 

library(doMC)
library(parallel)
library(dplyr)
library(data.table)
library(httr)
library(xml2)
library (plyr)
library(zoo)
require(lubridate)
library(calibrate)
library(psych)
library(OpenMx)

cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}

noCores <- detectCores() - 1
registerDoMC(noCores)



## Open in the environment the thickers
tickers <- read.csv("/home/davide/thickers.csv")
#tickers <- read.csv("./covar_me/data/tickers.csv")
#returns <- read.table("./covar_me/data/returns.txt")
start_date <- returns$date[1]
returns$date <- as.character(returns$date)

## Rescale by 100 to avoid underflow
returns$mkt_return <- returns$mkt_return*100
returns$rf <- returns$rf*100


start_pos <- as.POSIXct(start_date, origin="1970-01-01")
end_pos   <- as.POSIXct("2016-08-01", origin="1970-01-01")



## HELPER FUNCTION 1

## The function compute the variance of a given portfolio on a time period
## Given the weights and the correspondig tickers

compute_var_on_weights <- function(weights, tick, start, end){
  
  estimates  <- tryCatch(foreach(n = c(1:length(tick)), .combine = append) %dopar%{
    nn <- as.character(tick[n])
    ## Query the database
    aa <- tryCatch(GET(paste0("http://52.213.127.11:9001/api/query/?start=",start,"&end=", end, "&m=sum:",
                              nn,".return{company=",nn,"}")), error=function(e){})
    if(is.null(aa)==FALSE){
      
      encoded <- content(aa, as = "parse", encoding = "utf-8")
      ret <- unlist(encoded)[-c(1,2,3)]
      time <- substr(names(ret), 5, nchar(names(ret)))
      time <- as.character(as.Date(as.POSIXct(as.numeric(time), origin="1970-01-01")))
      vector <- as.data.frame(cbind(time = time, ret=as.vector(ret)))
      vector[,2] <- 100*as.numeric(as.character(vector[,2]))
      vector[,1] <- as.character(vector[,1])
      names(vector) <- c("date","stockreturn")
      list(name= nn, ret = vector$stockreturn,date=vector$date)
    }
  }, error=function(e){})  
  
  if (is.null(estimates)==FALSE){
    
      ## Create the matrix with returns from queries
      X <- foreach(n = seq(from=2,to=length(estimates), by=3), .combine = function(x,y)(merge(x,y,by="date",all=T))) %do% {
      column_ret <- as.vector(unlist(estimates[n]))
      if (is.na(column_ret)==FALSE){
        column_date <- as.vector(unlist(estimates[n+1]))
        xx <- data.frame(cbind(ret=column_ret,date = column_date))
        names(xx) <- c(as.character(unlist(estimates[n-1])), "date")
        xx  
      }
    }
    ## Some data cleaning
    X <- apply(X,2,as.numeric)
    X <- as.matrix(X[,-1])
    ## Kill observations with too many NAs
    X<- X[,colSums(is.na(X))<nrow(X)*3/4]
    names <- tick[tick %in% colnames(X)]
    ww <- weights[tick %in% colnames(X)]
    X <- X[,names]
    ## Replace zeros in NA to avoid their computations in the matrix multiplication
    X[is.na(X)] <- 0 ##Brute force approach: underestimate the varince
    ## compute return variance
    var <- var(X%*%as.vector(ww))
    return(var)
  }
}




## HELPER FUNCTION 2


## Compute covariance matrix, mean vector and in sample best weights

compute_cov <- function(returns,tickers, alpha, target_ret, method=NULL, n_stock=100, start="1262563200", end="1470002400"){
  ## Match regressions by dates, same of previous function
  estimates  <- foreach(n = c(1:n_stock), .combine = append) %dopar%{
    
    nn <- as.character(tickers[n,1])
    aa <- tryCatch(GET(paste0("http://52.213.127.11:9001/api/query/?start=",start,"&end=", end, "&m=sum:",
                              nn,".return{company=",nn,"}")), error=function(e){})
    
    if(is.null(aa)==FALSE){
      
      encoded <- content(aa, as = "parse", encoding = "utf-8")
      ret <- unlist(encoded)[-c(1,2,3)]
      time <- substr(names(ret), 5, nchar(names(ret)))
      time <- as.character(as.Date(as.POSIXct(as.numeric(time), origin="1970-01-01")))
      vector <- as.data.frame(cbind(time = time, ret=as.vector(ret)))
      vector[,2] <- 100*as.numeric(as.character(vector[,2]))
      vector[,1] <- as.character(vector[,1])
      
      names(vector) <- c("date","stockreturn")
      X <- returns[as.character(returns$date) %in% vector$date,]
      X <- X[!duplicated(X$date),]
      vector <- vector[vector$date %in% X$date,]
      dd <- merge(vector, X, by="date", all=T)
      ## Compute the regression coefficients from one single factor model
      reg <- tryCatch(lm(I(stockreturn-rf)~I(mkt_return - rf), data=dd), error=function(e){})
      if(is.null(reg)==FALSE){
        b1 <- coef(reg)[2]
        epselon <- na.omit(dd$stockreturn) - predict(reg)
        residual_var <- var(epselon)
        ## Keep track also of the company 
        list(b1 = b1,res=residual_var, name = nn, ret = vector$stockreturn,date=vector$date)
      }
    }  
  }
  
  if (is.null(estimates)==FALSE){
    
    ## Biased variance estimator:
    betas <- matrix(estimates[seq(from=1,to=length(estimates), by=5)])
    betas <- as.numeric(as.character(betas))
    mkt_variance <- var(returns$mkt_return)
    res_var <- matrix(estimates[seq(from=2,to=length(estimates), by=5)])
    res_var <- as.numeric(as.character(res_var))
    names <- matrix(estimates[seq(from=3,to=length(estimates), by=5)])
    
    ## Compute the X of returns
    X <- foreach(n = seq(from=4,to=length(estimates), by=5), .combine = function(x,y)(merge(x,y,by="date",all=T))) %do% {
      column_ret <- as.vector(unlist(estimates[n]))
      column_date <- as.vector(unlist(estimates[n+1]))
      xx <- data.frame(cbind(ret=column_ret,date = column_date))
      names(xx) <- c(as.character(unlist(estimates[n-1])), "date")
      xx }
    
    ## Data cleaning
    
    X <- apply(X,2,as.numeric)
    X <- as.matrix(X[,-1])
    ## deal with missing values treshold on 1/4 or greater NA
    betas <- betas[colSums(is.na(X))<nrow(X)*3/4]
    res_var <- res_var[colSums(is.na(X))<nrow(X)*3/4]
    ind <- apply(X, 1, function(x) all(is.na(x)))
    X <- X[ !ind, ]
    X<- X[,colSums(is.na(X))<nrow(X)*3/4]
    ## Replace zeros in NA to avoid their computations in the matrix multiplication
    X[is.na(X)] <- 0 ##Brute force approach
    ## Wolf and Ledoit method
    mu <- apply(X, 2, function(x)(mean(x,na.rm=T)))
    S <- (t(X)%*%X)/length(X[,1]) - mu%*%t(mu)
    Phi <- mkt_variance*(betas%*%t(betas)) + diag(res_var)
    Sigma <- alpha*S + (1-alpha)*Phi
    diagonalization <- eigen(Sigma,TRUE)
    Q <- unlist(diagonalization[[2]])
    
    
    ## Store A
    ## Invert using the spectral decomposition
    Precision <- Q%*%diag(1/unlist(diagonalization[[1]]))%*%t(Q) 
    rm(Q)
    ## Compute weights
    target_ret <- target_ret
    A <- t(rep(1, dim(Precision)[1]))%*%Precision%*%rep(1, dim(Precision)[1])
    B <- t(rep(1, dim(Precision)[1]))%*%Precision%*%mu
    C <- t(mu)%*%Precision%*%mu
    weight <- as.numeric((C - target_ret*B)/(A*C- B^2))*(Precision%*%rep(1,dim(Precision)[1])) + 
      as.numeric((target_ret*A-B)/(A*C - B^2))*Precision%*%mu
    port_var <- t(weight)%*%Sigma%*%weight
    
    if(method=="Test"){
      
      ## Test with a diagonal matrix with variances on the diagonal 
      
      Precision_diag <- diag(as.vector(1/diag2vec(S)))
      Sigma_diag <- diag(as.vector(diag2vec(S)))
      A <- t(rep(1, dim(Precision_diag)[1]))%*%Precision_diag%*%rep(1, dim(Precision_diag)[1])
      B <- t(rep(1, dim(Precision_diag)[1]))%*%Precision_diag%*%mu
      C <- t(mu)%*%Precision_diag%*%mu
      weight_diag <- as.numeric((C - target_ret*B)/(A*C- B^2))*(Precision_diag%*%rep(1,dim(Precision_diag)[1])) + 
        as.numeric((target_ret*A-B)/(A*C - B^2))*Precision_diag%*%mu
      port_var_diag <- t(weight_diag)%*%Sigma_diag%*%weight_diag
      
      return(list(Sigma=Sigma,Precision = Precision,weights = weight,tot_var = port_var,names = names, mean=mu, test=port_var_diag, w_diag=weight_diag)) 
      
    } else {
      return(list(Sigma=Sigma,Precision = Precision,weights = weight,tot_var = port_var,names = names, mean=mu))} 
  } }




## Function to do cross validation on time serie

cross_validate <- function(returns, tickers, train_period, alpha, target, n_stock){
  
  ## define the whole sequence of the period
  sequence <- seq(from=start_pos,to=end_pos, by="month")
  sequence <- as.character(as.numeric(sequence))
  ## Drop the first periods module of the train period
  if (length(sequence)%%train_period == 0){
    sequence <- sequence[-c(1:(train_period - 1))]} else if (length(sequence)%%train_period != 1){
      sequence <- sequence[-c(1:(length(sequence)%%train_period - 1))]}
  
  ## Loop in parallel
  mspe <- foreach(i=seq(from=1,to=(length(sequence) - train_period), by=(train_period+1)), .combine=rbind) %dopar% {
    ## Compute in sample variables
    values <- tryCatch(compute_cov(returns, tickers, alpha, target, "No test", n_stock=n_stock,start=sequence[i],end=sequence[i+train_period]),
                       error=function(e){"WTF"})
    ## Some error handling
  if(is.null(values)==FALSE && values != "WTF"){
      
  w_train <- as.numeric(as.character(unlist(values[3])))
  ## Compute the test error
  test_var <- tryCatch(compute_var_on_weights(w_train, tick=as.character(unlist(values[5])),  
      start=sequence[i+train_period+1], end=sequence[i+train_period+2]), error=function(e){"Stronzone errore"})
      
  if (test_var == "Stronzone errore"){
        c(out_of_sample = NA, in_sample=unlist(values[4]))} else {
          c(out_of_sample = test_var, in_sample=unlist(values[4]))} }
}

  return(mspe)

}







