tab2fisher <- function(tab){
	tmp <- matrix(as.numeric(c(tab[1],tab[2],tab[3],tab[4])),nrow=2)
	fisher.test(tmp)$p.value
}

data <- as.matrix(read.table("counts.csv",sep=",", header=F))

#空集合を表す1を除去
data <- data[which(data[,5]!=1),]

#p値を得る
ps <- apply(data,1,tab2fisher)
cbind(data,ps)

#PDFに出力
par(mfrow=c(1,2))
plot(sort(ps))
marker <- paste(data[,5], collapse=" ")
marker <-as.numeric(unlist(strsplit(marker, " ")))-3
hist(marker,breaks=seq(0, 3000, by=100))
