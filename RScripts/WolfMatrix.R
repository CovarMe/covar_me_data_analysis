library(foreach)
library(doMC)
library(parallel)
library(dplyr)
library(data.table)
library(httr)
library(xml2)
library (plyr)
library(zoo)
library(KFAS) ## for ldl decomposition
library(quadprog) ## To solve the minimization problem using quadratic proramming



## Change data <- totstock to run on the machine 
## Query on the shortstock including just variables of interest

data <- shortstock
data$date  <- as.Date(strptime(as.character(data$date), "%d/%m/%Y"))
data$COMNAM <- as.character(data$COMNAM)
data$RET <- as.numeric(as.character(data$RET))
## define one vector for each stock: 
## use return of single stock as shortstock$ewretd
## use market return as sortstock$sprtr  (ASSUMPTION mkt return and index return coincides)
## All other variables should be dropped!

## Vector of market returns

mktreturn <- as.data.frame(cbind(mkt_return = data[!duplicated(data$date),]$sprtr, date= as.character(data[!duplicated(data$date),]$date)))
companynames <- as.character(unique(data$COMNAM))

## To be fixed: We need the dayly return on US bonds
## Name the data
USInterest <- TreasuryReturnsUS

## Use the Treasury bills return: note to create the dayly we use the compound formula
daylyriskfreerate <- (1 + as.numeric(USInterest$X1month)/100)^(1/30) - 1 
risk_free_matrix <- as.data.frame(cbind(rf=daylyriskfreerate, date=as.character(USInterest[,1])))

## Make the dates comparable between the 2 datasets
risk_free_matrix[,2] <- paste0("20",substr(as.character(risk_free_matrix[,2]), 7 , 9),
                               "-",substr(as.character(risk_free_matrix[,2]), 0 , 2),"-",
                               substr(as.character(risk_free_matrix[,2]), 4 , 5)) 


## Screen and pick only the ones in the same date of mkreturn
risk_free_matrix <- risk_free_matrix[as.character(risk_free_matrix$date) %in% as.character(mktreturn[,2]),]

## Drop observation in mktreturn not in risk_free_matrix
mktreturn <- mktreturn[as.character(mktreturn[,2]) %in% as.character(risk_free_matrix$date),]
returns <- merge(mktreturn, risk_free_matrix, by="date")
returns$mkt_return <- as.numeric(as.character(returns$mkt_return))
returns$rf <- as.numeric(as.character(returns$rf))
returns$date <- as.character(returns$date)

## Create a list with a vector of return for each company: use parallel computation


## Subset according to your time window
initial <- as.Date(strptime("2010-01-01", "%Y-%m-%d"))
end     <- as.Date(strptime("2015-12-31", "%Y-%m-%d"))
returns$date <- as.Date(strptime(as.character(returns$date), "%Y-%m-%d"))

## To select the window we only need to select it from returns
returns <- filter(returns, date > initial & date < end)

noCores <- detectCores() - 1
registerDoMC(noCores)

## Note: make a list because not all companies have the same number of days

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
rm(estimates, listofreturns, companynames)

## filter the companies with our names
data <-  filter(data, COMNAM %in% names)

## filter the data with dates in mktreturn dates
data <- filter(data, date %in% returns$date)

## S: sample covariance, Phi is the prior, alpha is the shrinkage paramete


X <- foreach(n = names, .combine = function(x,y)(merge(x,y,by="date")), .init=returns) %dopar% {
     filtered <- filter(data, COMNAM == n)
     filtered <- filter(filtered, date %in% returns$date)
     xx <- data.frame(cbind(filtered$RET,date =filtered$date))
     names(xx) <- c(as.character(n), "date")
     xx }
X <- X[,names]
X <- apply(X,2,as.numeric)
## Interpolate missing column values using spline approximation
X <- apply(X,2, na.spline)
rm(data)


S <- t(X)%*%X
Phi <- mkt_variance*(betas%*%t(betas)) + diag(res_var)

## Example 
alpha <- 1/2 
Sigma <- alpha*S + alpha*Phi
diagonalization <- eigen(A,TRUE)
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

             
## Working on Wolf Ledoit regularization parameter alpha: To be finished

X_centered <- apply(X, 2, function(x)(x - mean(x)))



p <- foreach(i = 1:(dim(X)[2]-1), .combine= function(x,y)(sum(x,y))) %dopar%{
  foreach(n = (i+1):dim(X)[2], .combine =function(x,y)(sum(x,y))) %dopar%{
    sum((X_centered[,i]*X_centered[,n] - S[i,n])^2)*1/dim(X)[1]  }
}



registerDoSEQ()
