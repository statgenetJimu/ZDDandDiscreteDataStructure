library('stringr')

cases <- conts <- c()
data <- scan("permdata/haps.txt", what=character(), sep="\n")

for(i in 1:length(data)){
	tmp <- str_split(data[[i]], " ")[[1]]
	if(tmp[1]==2){
		cases <- c(cases, tmp[-1])
	} else {
		conts <- c(conts, tmp[-1])
	}
}

ca <- as.numeric(cases)
co <- as.numeric(conts)

data.lcm <- scan("permdata/FQ.txt", what=character(), sep="\n")

collapse.lcm <- function(item){
	tmp <-  c()
	for(i in 2:length(item)){
		tmp <- c(tmp, rep(sub("x", "", item[i]),as.numeric(item[1])))
	}
	return(tmp)
}


lcm.ca <- str_split(data.lcm[1], " \\+ ")[[1]]
lcm.ca <- str_split(lcm.ca, " ")
lcm.co <- str_split(data.lcm[2], " \\+ ")[[1]]
lcm.co <- str_split(lcm.co, " ")
FQ.ca <- as.integer(na.exclude(as.numeric(unlist(lapply(lcm.ca, collapse.lcm)))))
FQ.co <- as.integer(na.exclude(as.numeric(unlist(lapply(lcm.co, collapse.lcm)))))


xlim <- c(0,20)
ylim <- c(0,300)
breaks <- seq(4, 1004) 


if(sum(FQ.ca) != 0){
	hist(FQ.ca, col=rgb(0,0,0, alpha=0.3), xlim=xlim, ylim=ylim)
}
if(sum(FQ.co) != 0){
	par(new=T)
	hist(FQ.co, col=rgb(0,0,0, alpha=0.3), xlim=xlim, ylim=ylim)
}

par(new=T)
hist(ca, col=rgb(0,0,0, alpha=0.25), xlim=xlim, ylim=ylim, breaks=breaks)
par(new=T)
hist(co, col=rgb(0,0,0, alpha=0.25), xlim=xlim, ylim=ylim, breaks=breaks)
