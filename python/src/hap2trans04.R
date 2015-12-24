n.sample <- 200
n.gene <- 1000
g <- matrix(sample(0:1,n.sample*n.gene,replace=TRUE,prob=c(0.7,0.3)),nrow=n.sample)

n.e <- 10
rs <- rpois(n.e,2)
effects <- sample(1:n.e)

cmb <- list()
for(i in 1:n.e){
  cmb[[i]] <- sample(1:n.gene,rs[i])
}

scores <- rep(0,n.sample)
for(i in 1:n.e){
  if(length(cmb[[i]])!=0){
    tmp <- matrix(g[,cmb[[i]]],nrow=n.sample)
    tmp2 <- apply(tmp,1,prod)
    tmp3 <- which(tmp2==1)
    if(length(tmp3)>0){
      scores[tmp3] <- scores[tmp3] + effects[i]
    }
  }
}

phenotype <- rep(0,n.sample)
phenotype[which(scores > quantile(scores,0.5))] <- 1

tab <- list()
for(i in 1:n.sample){
	if(phenotype[i]==0){
		tab[[i]] <- c(3, (which(g[i,]==1)+4))
	} else {
		tab[[i]] <- c(2, (which(g[i,]==1)+4))
	}
}

outtab <- c()
for(i in tab){
	tmp <- paste(i,  collapse=" ")
	outtab <- append(outtab, tmp)
}
out <- file("trans.txt", "w")
write.table(outtab, out, row.names=F, col.names=F, quote=F)
close(out)
#g. = lapply(g., function(x) paste(
#print(g.)
#for(i in 1:length(g.)){
#  ca  <-  paste(g.[[i]], collapse=" ")
#  tab <- append(tab,ca)
#}
#for(i in 1:length(g.diff)){
#  ca.diff <- paste(g.diff[[i]],collapse=" ")
#  tab.diff <- append(tab.diff,ca.diff)
#}
#out <- file("trans.txt", "w")
#write.table(tab,out,row.names=F,col.names=F,quote=F)
#close(out)
#out <- file("trans_diff.txt","w")
#write.table(tab.diff,out,row.names=F,col.names=F,quote=F)
#close(out)
#}

order <- seq(1:n.gene+4)
order <- paste(order,collapse=" ")
out2 <- file("order.txt", "w")
write.table(order,out2,row.names=F,col.names=F,quote=F)
close(out2)

