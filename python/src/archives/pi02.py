from graphillion import GraphSet
import pickle
from itertools import chain
import csv

import networkx as nx
import matplotlib.pyplot as plt

haps = [[1,0,1],[0,0,1],[0,1,1],[0,1,0],[1,1,1]]

n = len(haps[1])
ng = len(haps)

universe = []

for i in range(n):
    universe.append((i,i+1))

GraphSet.set_universe(universe)

g_univ = GraphSet({})

g1 = []

i = 1
for i in range(ng):
    tmp = []
    for j in range(n):
        if haps[i][j] == 1:
            tmp.append(universe[j])
        if i == 0:
            g1 = [tmp]
        else :
            g1.append(tmp)
G1 = GraphSet(g1)
data = map(lambda x:x.split(" "), G1.dumps().strip().split("\n"))
data.pop()
print data
f=open("ZDD.csv", "wb")
writer=csv.writer(f)
for i in data:
    writer.writerow(i)
f.close
