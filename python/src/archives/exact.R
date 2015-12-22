n = 200 
na = 80
no = n-na
x = 30
y = n-x


pval=c()
numx=c()
for (i in 1:min(x,na)){
	a = i
	b = na-a 
	c = x-i
	d = no-c
	tab = matrix(c(a,b,c,d), nrow=2)
	print(tab)
	numx = append(numx, i)
	pval = append(pval, fisher.test(tab)$p.value)
	table = cbind(numx, pval)	
}

plot(numx, pval)
print(table[which(pval<0.1)])
