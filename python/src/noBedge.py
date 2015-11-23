#coding: UTF-8

from graphillion import GraphSet
import pickle
import networkx as nx
from itertools import chain
import matplotlib.pyplot as plt
import numpy as np
import random

gene = 10 
samp = 100

universe = []
for i in range(gene):
    universe.append((int(i), int(i)+1))

GraphSet.set_universe(universe)

dics = random.sample(range(2**gene), samp)
bins = []
#桁数の扱いに問題があったので修正しました
keta = "0" + str(gene) + "b"
for dic in dics:
    bins.append(format(dic, keta))

haplos = [map(int, [n for n in x]) for x in bins]

G1 = []
for j in range(len(haplos)):
    haplo = haplos[j]
    haploedges = []
    for i in range(len(haplo)):
        if haplo[i] == 1:
            haploedges.append(universe[i])
        G1.append(haploedges)

G1 = GraphSet(G1)

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

plt.show()
