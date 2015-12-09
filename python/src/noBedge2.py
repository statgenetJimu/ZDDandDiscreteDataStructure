#coding: UTF-8

from graphillion import GraphSet
import pickle
import networkx as nx
from itertools import chain
import matplotlib.pyplot as plt
from numpy import *
import numpy as np

ncase = 3
ncont = 3
nmarker = 15 

hapcase = []
hapcont = []
for i in range(ncase):
    hapcase.append(random.choice([0,1],nmarker))

for i in range(ncont):
    hapcont.append(random.choice([0,1],nmarker))

ins_loc = 10
map(lambda k:insert(k,ins_loc,1),hapcase)
map(lambda k:insert(k,ins_loc,0),hapcase)
map(lambda k:append(k,1),hapcase)
map(lambda k:append(k,0),hapcont)

haps = hapcase
haps.extend(hapcont)

n = len(haps[1])
ng = len(haps)

universe = []
for i in range(n):
    universe.append((i, i+1))

GraphSet.set_universe(universe)

g_unive = GraphSet({})
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
#print(G1.dumps())

data = map (lambda x:x.split(" "), G1.dumps().strip().split("\n"))
data.pop()
data_f1 = list(chain.from_iterable(data))
len_data_f1 = len(data_f1)
num_v = len_data_f1/4

v_id  = data_f1[0::4]
v_lab = data_f1[1::4]
v_lo  = data_f1[2::4]
v_hi  = data_f1[3::4]

e_lo = []
e_hi = []
e_type_lo = []
e_type_hi = []
v_lab_num = []

for i in range(len(v_id)):
    e_lo.append((v_id[i], v_lo[i]))
    e_hi.append((v_id[i], v_hi[i]))
    e_type_lo.append("b")
    e_type_hi.append("r")
    v_lab_num.append(int(v_lab[i]))

#行先にBを含むlo枝を削除
e_lo = [x for x in e_lo if "B" not in x]

gg = nx.Graph()
gg.add_edges_from(e_lo, color="b")
gg.add_edges_from(e_hi, color="r")

st = 0.0
pos1 = [float(v_lab[0])]
pos2 = [st]
pos = {v_id[0]:[float(v_lab[0]), st]}
for i in range(1, len(v_id)):
    if v_lab_num[i] == v_lab_num[i-1]:
        st += 1.0
    else:
        st =  0.0
    pos[v_id[i]] = [float(v_lab[i]),st]
    pos1.append(pos[v_id[i]][0])
    pos2.append(pos[v_id[i]][1])

pos["T"] = [max(pos1)+1, 0.0]

nx.draw_networkx_nodes(gg, pos, node_color="gray", node_size=10)
nx.draw_networkx_nodes(gg, pos, nodelist=["T"], node_color="r", node_size=10)
nx.draw_networkx_edges(gg, pos, e_lo, edge_color = "blue", alpha = 0.1)
nx.draw_networkx_edges(gg, pos, e_hi, edge_color = "r")


countslab = []
for i in range(1, nmarker+1):
    countslab.append(v_lab.count(str(i)))

countsin  = []
countsout = []
for i in v_id:
    countsin.append(v_lo.count(str(i)))
    countsout.append(v_hi.count(str(i)))

#v_lab = map(int, v_lab)
#v_hi = map(int, v_hi)
#V_lo = map(int, v_lo)
import numpy as np
a = np.array([v_id, v_hi, v_lo, v_lab])
print a
plt.show()
