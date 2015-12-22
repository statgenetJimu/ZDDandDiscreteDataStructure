# coding: UTF-8

from graphillion import GraphSet
import pickle
from itertools import chain

import networkx as nx
import matplotlib.pyplot as plt

n = 10
universe = []
for i in range(n):
  universe.append((i,i+1))

for i in universe:
  print i

GraphSet.set_universe(universe)

ng = 20

g_univ = GraphSet({})

g1 = []
i = 1
for sg in g_univ.rand_iter():
  g1.append(sg)
  if i == ng: break
  i += 1

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
st = 0.0 + 0.1 * v_lab_num[0]
pos = {v_id[0]:[float(v_lab[0]),st]}
pos1 = [float(v_lab[0])]
pos2 = [st]
for i in range(1,len(v_id)):
  if v_lab_num[i-1]==v_lab_num[i]:
    st += 1.0
  else:
    st = 0.0 + 0.1 * v_lab_num[i]
  pos[v_id[i]] = [float(v_lab[i]),st]
  pos1.append(pos[v_id[i]][0])
  pos2.append(pos[v_id[i]][1])

#pos['T'] = [max(pos1)+1,0.0 + 0.1 * (v_lab_num[0]+1)]
pos['T'] = [max(pos1)+1,min(pos2)-1]
pos['B'] = [max(pos1)+1,max(pos2)+1]
#nx.draw(gg)
nx.draw_networkx_nodes(gg,pos,node_color='gray',node_size=10)
nx.draw_networkx_nodes(gg,pos,nodelist=['T'],node_color='r',node_size=10)
nx.draw_networkx_nodes(gg,pos,nodelist=['B'],node_color='blue',node_size=10)

nx.draw_networkx_edges(gg,pos,e_lo,edge_color='gray',alpha=0.5,width=2.0)
nx.draw_networkx_edges(gg,pos,e_hi,edge_color='r',style='dashed')
plt.show()

