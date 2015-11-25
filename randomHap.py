# coding: UTF-8

from graphillion import GraphSet
import pickle
from itertools import chain

import networkx as nx
import matplotlib.pyplot as plt
from numpy import *

import random


ncase = 20
ncont = 21
ncaco = ncase + ncont

nmarker = 25

dics = random.sample(range(2**nmarker), ncaco)
bins = []
for dic in dics:
     bins.append(format (dic, 'b').zfill(nmarker))

haps = [map(int,[n for n in x]) for x in bins]

for i in range(ncaco):
    if i < ncase:
        haps[i].append(1)
    else:
        haps[i].append(0)



#haps = [[0,0,0],[0,0,1],[0,1,0],[1,1,1]]
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
print(G1.dumps())

data = map (lambda x:x.split(" "),G1.dumps().strip().split("\n"))
data.pop()


data_fl = list(chain.from_iterable(data))

len_data_fl = len(data_fl)
num_v = len_data_fl/4

v_id = data_fl[::4]
v_lab = data_fl[1::4]
v_lo = data_fl[2::4]
v_hi = data_fl[3::4]

e_lo = []
e_hi = []
e_type_lo = []
e_type_hi = []
v_lab_num = []
for i in range(len(v_id)):
  e_lo.append((v_id[i],v_lo[i]))
  e_hi.append((v_id[i],v_hi[i]))
  e_type_lo.append("b")
  e_type_hi.append("r")
  v_lab_num.append(int(v_lab[i]))

gg = nx.Graph()

gg.add_edges_from(e_lo,color='b')
gg.add_edges_from(e_hi,color='r')

#pos = nx.spring_layout(gg)
K = 1

st = 0.0 + 0.1 * (v_lab_num[i]+1)**K
pos = {v_id[0]:[float(v_lab[0]),st]}
pos1 = [float(v_lab[0])]
pos2 = [st]
for i in range(1,len(v_id)):
  if v_lab_num[i-1]==v_lab_num[i]:
    st += 1.0 + v_lab_num[i]
  else:
    st = 0.0 + 0.1 * (v_lab_num[i]+1)**K
  pos[v_id[i]] = [float(v_lab[i]),st]
  pos1.append(pos[v_id[i]][0])
  pos2.append(pos[v_id[i]][1])

pos['T'] = [max(pos1)+1,min(pos2)-1]
pos['B'] = [max(pos1)+1,max(pos2)+1]
#nx.draw(gg)
nx.draw_networkx_nodes(gg,pos,node_color='gray',node_size=10)
nx.draw_networkx_nodes(gg,pos,nodelist=['T'],node_color='r',node_size=10)
nx.draw_networkx_nodes(gg,pos,nodelist=['B'],node_color='blue',node_size=10)

nx.draw_networkx_edges(gg,pos,e_lo,edge_color='gray',alpha=0.6,width=2.0)
nx.draw_networkx_edges(gg,pos,e_hi,edge_color='r',style='dashed')
plt.show()