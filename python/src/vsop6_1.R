hap <- function(t,p){
	return(rbinom(t,1,p))
}

#引数:マーカー数,背景SNPのMAF,責任SNP数/MAF, 表現型(0=control)
#表現型ヘッダcase=2,control=3のあとにハプロタイプの続くスペースで区切られた文字列を返す
make.hap <- function(n.gene, p.bcg, n.mkr=0, p.mkr=0, phe=0){
	sep <- c(4:(n.gene+3))
	tmp <- hap(n.mkr,p.mkr)
	tmp <- append(tmp,hap(n.gene-n.mkr, p.bcg))*sep
	if(phe==1){
		tmp <- append(c(2,0),tmp)
	} else {
		tmp <- append(c(0,3),tmp)
	}
	tmp <- tmp[tmp !=0]
	tmp <- paste(tmp, collapse=" ")
	return(tmp)
}

#orderファイルを作る
make.order <- function(n.gene){
	order <- seq(1:n.gene)
	order <- paste(order, collapse=" ")
	write.table(order, "order.txt", row.names=F, col.names=F, quote=F)
}

#トランザクションファイルを作る
#途中でmake.orderも読んでおく
#引数: 総SNP数、背景SNPのMAF, 責任SNP数/MAF, caseの数、controlの数
make.trans <- function(n.gene, p.bcg, n.mkr, p.mkr, n.case, n.cont){
	tmp <- c()
	for(i in 1:n.case){
			tmp <- append(tmp, make.hap(n.gene, p.bcg, n.mkr, p.mkr, phe=1))
	}
	for(i in 1:(n.cont)){
			tmp <- append(tmp, make.hap(n.gene, p.bcg))
		}	
	order <- make.order(n.gene+3)
	write.table(tmp, "trans.txt", row.names=F, col.names=F, quote=F)
}

#マーカー数3000, 背景SNPのMAF 2%, 責任SNP50個のMAF 10%, case 200例, control 200例
make.trans(3000,0.02,50,0.10,200,200)
