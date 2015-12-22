library('stringr')

read.transaction <- function(data){
	cases <- conts <- c()
	data <- scan(data, what=character(), sep="\n")
	for(i in 1:length(data)){
		tmp <- str_split(data[[i]], " ")[[1]]
		if(tmp[1]==2){
			cases <- c(cases, tmp[-1])
		} else {
			conts <- c(conts, tmp[-1])
		}
	}
	return(list(as.numeric(cases), as.numeric(conts)))
}

collapse.lcm <- function(item){
	tmp <- c()
	for(i in 2:length(item)){
		tmp <- c(tmp, rep(sub("x", "", item[i]), as.numeric(item[1])))
	}
	return(tmp)
}

read.zdd <- function(data){
	tmp <- scan(data, what=character(), sep="\n")
	tmp <- str_split(tmp[[1]], " \\+ ")[[1]]
	tmp <- str_split(tmp, " ")
	tmp <- as.integer(na.exclude(as.numeric(unlist(lapply(tmp,collapse.lcm)))))
return(tmp)
}

haps <- read.transaction("trans.txt")
FQca <- read.zdd("permdata/FQca.txt")
FQco <- read.zdd("permdata/FQco.txt")
par(mfrow=c(1,2))
x=c(1,1004)
y=c(1,500)
b=1000
hist(FQca,col=rgb(0.5,0,0, alpha=0.4),xlim=x, ylim=y, breaks=11)
par(new=T)
hist(haps[[1]],xlim=x, ylim=y, breaks=b)
if(length(FQco)!=0){
	hist(FQco,col=rgb(0.5,0,0, alpha=0.4),xlim=x, ylim=y, breaks=11)
	par(new=T)
}
hist(haps[[2]],xlim=x, ylim=y, breaks=b)

#MQca <- read.zdd("permdata/MQca.txt")
#MQco <- read.zdd("permdata/MQco.txt")

#hist(MQca,col=rgb(0.5,0,0, alpha=0.4),xlim=x, ylim=y, breaks=11)
#par(new=T)
#hist(haps[[1]],xlim=x, ylim=y, breaks=b)
#par(new=T)
#hist(haps[[2]],xlim=x, ylim=y, breaks=b)
