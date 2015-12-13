require "zdd"
require "matrix"

#下記のようなハプロタイプを考える
#meetでは空集合が１とされるので、マーカーは２から始まることとする
#a=1111000000
#b=0111100000
#c=0011110000
#d=0001111000
#e=0000111100
#f=0000011110
#g=0000001111
#h=1000000111
#i=1100000011
a=ZDD::itemset("2 3 4 5")
b=ZDD::itemset("3 4 5 6")
c=ZDD::itemset("4 5 6 7")
d=ZDD::itemset("5 6 7 8")
e=ZDD::itemset("6 7 8 9")
f=ZDD::itemset("7 8 9 10")
g=ZDD::itemset("8 9 10 11")
h=ZDD::itemset("2 9 10 11")
i=ZDD::itemset("2 3 10 11")

set = a+b+c
print "print.set"
print set
print "print set.meet(set)"
print set.meet(set)


