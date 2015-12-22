data <- read.table("ZDD.csv", sep=",")
num <-rev(seq(1:nrow(data)))
print(data)

data <- data[num,]
lab  <- data[,1]
lo   <- data[,3]
hi   <- data[,4]

mat <- matrix(0, nrow=(length(lab)+2), ncol=(length(lab)+2))
lab <- append(lab,c("T","B"))
colnames(mat) <- lab
rownames(mat) <- lab

mat[1,1] <- 1
for(i in 1:nrow(data)){
    r  <- which(lab == data[i,1])
    cl <- which(lab == data[i,3])
    ch <- which(lab == data[i,4])
    mat[cl,r] =+ 1
    mat[ch,r] =+ 1
}
print(((mat%*%mat)%*%mat)%*%mat)
