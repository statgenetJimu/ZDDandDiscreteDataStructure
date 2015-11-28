# coding:UTF-8

from  graphillion import GraphSet
from numpy import *

n = 3
marker = 2 
#haps = []
#for i in range(n):
#    haps.append(random.choice([0,1], marker))
haps=[(0,1),(0,0),(1,1)]

universe = []
for i in range(marker):
    universe.append((i, i+1))

GraphSet.set_universe(universe)

g1 = []
i = 1
for i in range(n):
    tmp = []
    for j in range(marker):            
        if haps[i][j] == 1:
            tmp.append(universe[j])
    if i == 0:
        g1 == [tmp]
    else:
        g1.append(tmp)

G1 = GraphSet(g1)
print "haps"
print haps
print "\nuniverse"
print universe
print "\ng1"
print g1
print "\nG1"
print G1
print "\nG1.dumps()"
print G1.dumps()
