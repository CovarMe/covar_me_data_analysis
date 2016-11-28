#!/usr/bin/env Rscript
library("optparse")

opt_list = list(make_option(c("-H", "--host"), 
                            type = "character", 
                            default = "127.0.0.1", 
                            help = "database host (defaults to localhost)", 
                            metavar = "character"),
                make_option(c("-f", "--file"), 
                            type = "character", 
                            default = NULL, 
                            help = "matrix txt file", 
                            metavar = "character"))

opt_parser = OptionParser(option_list = opt_list)
opt = parse_args(opt_parser)

source('mongodb_matrix.R')

the.matrix <- read.table(opt$file)

create.mongodb.matrix(the.matrix, opt$host)

