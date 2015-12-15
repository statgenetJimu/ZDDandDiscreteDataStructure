tab <- c()
n.case <- 100
n.cont <- 200
n.gene <- 1000

tabl <- list()

#2,3はフェノタイプにあけておく、4~13までが責任SNV、以降は背景SNV
for(i in 1:n.case){
	tmp <- sort(sample(14:n.gene, replace=F, rnorm(1,n.gene/100,n.gene/1000)))
	mkr <- sort(sample(4:13, replace=F,4))
	case <- paste(c(mkr, tmp),collapse=" ")
	tabl[[i]] <- case
	tab[[i]] <- paste("2", case, collapse=" ")
}

#コントロールは4~1000まで背景SNV
for(i in 1:n.cont){
	cont <- sort(sample(4:n.gene, replace=F, rnorm(1,n.gene/100,n.gene/1000)))
	cont <- paste(cont, collapse=" ")
	tabl[[i+n.case]] <- cont
	tab[[i+n.case]] <- paste("3", cont, collapse=" ")
}

write.table(tab, "trans.txt",row.names=F, col.names=F,  sep=",", quote=F)
write.table(paste(2:n.gene, collapse=" "), "order.txt",row.names=F, col.names=F,  sep=",", quote=F)

#上記で作成したハプロタイプベクター(4~1000)に対して、フェノタイプをパーミュテーションで割り付け
for(i in 1:5){
	perm <- sample(c(rep(2,n.case),rep(3,n.cont)),n.case+n.cont,replace=T)
	tab.perm <- paste(perm, tabl, collapase=" ")
	out <- c("perm", i, ".txt")
	out <- paste(out,collapse="")
	write.table(tab.perm, out,row.names=F, col.names=F,  sep=",", quote=F)
}

