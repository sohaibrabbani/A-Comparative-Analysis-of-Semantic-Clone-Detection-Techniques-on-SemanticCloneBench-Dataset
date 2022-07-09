args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (full path to csv files).n", call.=FALSE)
} else if (length(args)==1) {
  


packages <- c("parallelDist", "RcppArmadillo", "RcppParallel", "RcppXPtrUtils", "parallelDist", "Rcpp", "plyr")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())), repos = "http://cran.us.r-project.org")  
}

library("Rcpp")
library("plyr")
sourceCpp("bDist.cpp")

# Converts a binary integer vector into a packed raw vector,
# padding out at the end to make the input length a multiple of packWidth
packRow <- function(row, packWidth = 64L) {
  packBits(as.raw(c(row, rep(0, (packWidth - length(row)) %% packWidth))))
}

as.PackedMatrix <- function(x, packWidth = 64L) {
  UseMethod("as.PackedMatrix")
}

# Converts a binary integer matrix into a packed raw matrix
# padding out at the end to make the input length a multiple of packWidth
as.PackedMatrix.matrix <- function(x, packWidth = 64L) {
  stopifnot(packWidth %% 8 == 0, class(x) %in% c("matrix", "Matrix"))
  storage.mode(x) <- "raw"
  if (ncol(x) %% packWidth != 0) {
    x <- cbind(x, matrix(0L, nrow = nrow(x), ncol = packWidth - (ncol(x) %% packWidth)))
  }
  out <- packBits(t(x))
  dim(out) <- c(ncol(x) %/% 8, nrow(x))
  class(out) <- "PackedMatrix"
  out
}

# Converts back to an integer matrix
as.matrix.PackedMatrix <- function(x) {
  out <- rawToBits(x)
  dim(out) <- c(nrow(x) * 8L, ncol(x))
  storage.mode(out) <- "integer"
  t(out)
}

# Generates random sparse data for testing the main function
makeRandomData <- function(nObs, nVariables, maxBits, packed = FALSE) {
  x <- replicate(nObs, {
    y <- integer(nVariables)
    y[sample(nVariables, sample(maxBits, 1))] <- 1L
    if (packed) {
      packRow(y, 64L)
    } else {
      y
    }
  })
  if (packed) {
    class(x) <- "PackedMatrix"
    x
  } else {
    t(x)
  }
}

# Reads a binary matrix from file or character vector
# Borrows the first bit of code from read.table
readPackedMatrix <- function(file = NULL, text = NULL, packWidth = 64L) {
  if (missing(file) && !missing(text)) {
    file <- textConnection(text)
    on.exit(close(file))
  }
  if (is.character(file)) {
    file <- file(file, "rt")
    on.exit(close(file))
  }
  if (!inherits(file, "connection")) 
    stop("'file' must be a character string or connection")
  if (!isOpen(file, "rt")) {
    open(file, "rt")
    on.exit(close(file))
  }
  lst <- list()
  i <- 1
  while(length(line <- readLines(file, n = 1)) > 0) {
    lst[[i]] <- packRow(as.integer(strsplit(line, "", fixed = TRUE)[[1]]), packWidth = packWidth)
    i <- i + 1
  }
  out <- do.call("cbind", lst)
  class(out) <- "PackedMatrix"
  out
}

# Wrapper for the C++ code which 
binaryDist <- function(x) {
  if (class(x) != "PackedMatrix") {
    x <- as.PackedMatrix(x)
  }
  dst <- bDist(x)
  attr(dst, "Size") <- ncol(x)
  attr(dst, "Diag") <- attr(dst, "Upper") <- FALSE
  attr(dst, "method") <- "binary"
  attr(dst, "call") <- match.call()
  class(dst) <- "dist"
  dst
}
#my code starts
#setwd("F:/SaadArshad/output/303methods")

setwd(args[1])

#df = read.table("api_call_1000repo.csv",header=TRUE, sep = ",")[1:377429,]
#df = read.table("api_call_101reponew.csv",header=TRUE, sep = ",")

#bachon walall size
#df1 <- read.table("mid_density_test.csv",header=TRUE, sep = ",")
df = read.table("mid_apicall.csv",header=TRUE, sep = ",")

#baron wala size
#df1 <- read.table("mid_density_3apicalls_new.csv",header=TRUE, sep = ",")
#df = read.table("api_call_faceremserepo_3apicalls.csv",header=TRUE, sep = ",")


#df1 <- read.table("mid_density_dugeonmaster3.csv",header=TRUE, sep = ",")
#df = read.table("api_call_dungeonmaster2.csv",header=TRUE, sep = ",")

mytable <- table(df)
# below line replaces the numbers greater than 0 with a 1 to convert intoa  binary matrix
mytable <- as.matrix((mytable > 0) + 0)
#my code ends

#x <- makeRandomData(200, 40, maxBits = 5, packed = TRUE)
system.time(bd <- binaryDist(mytable))

#a<-1-bd

print("time for creating a matrix from bd is as follows:")
#system.time(b<-as.matrix(a))


#system.time(alpha<- as.dist(c))
#system.time(dist<- 1-alpha)

hc <- hclust(bd, "ave")
hc$height <- round(hc$height, 6) 
#plot(hc)
#clusterCut <- cutree(hc, h=0.5)
#write.csv(clusterCut, file = "done.csv")
# write.csv(clusterCut, file = "clusterIDs_faceremserepopoint9.csv")
# 
# clusterCut <- cutree(hc, h=0.2)
# write.csv(clusterCut, file = "clusterIDs_faceremserepopoint8.csv")
# 
 #clusterCut <- cutree(hc, h=0.3)
 #write.csv(clusterCut, file = "clusterIDs_saadtestpoint7.csv")
# 
 #clusterCut <- cutree(hc, h=0.4)
 #write.csv(clusterCut, file = "clusterIDs_saadtestpoint6.csv")
# 
 clusterCut <- cutree(hc, h=0.5)
 #write.csv(clusterCut, file = "mytestclusterIDs.csv")
 write.csv(clusterCut, file = "clusterIDs_point5_simple.csv")
# 
 clusterCut <- cutree(hc, h=0.6)
 write.csv(clusterCut, file = "clusterIDs_point4_simple.csv")
# 
 clusterCut <- cutree(hc, h=0.7)
 write.csv(clusterCut, file = "clusterIDs_point3_simple.csv")

clusterCut <- cutree(hc, h=0.8)
 write.csv(clusterCut, file = "clusterIDs_point2_simple.csv")

}


