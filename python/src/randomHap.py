# coding: UTF-8

from graphillion import GraphSet
import pickle
from itertools import chain

import networkx as nx
import matplotlib.pyplot as plt
from numpy import *

import random
import collections

def randomHapCaseCont(nmarker,ncase,ncont):
    ncaco = ncase + ncont
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
    return haps

def randomHap(nmarker,ncaco):
    dics = random.sample(range(2**nmarker), ncaco)
    bins = []
    for dic in dics:
         bins.append(format (dic, 'b').zfill(nmarker))
    
    haps = [map(int,[n for n in x]) for x in bins]
    return haps

def makeZDD(haps):
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
    return G1
    

def graphZDD(G):
    data = map (lambda x:x.split(" "),G.dumps().strip().split("\n"))
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
    return gg

def statZDD(G):
    data = map (lambda x:x.split(" "),G.dumps().strip().split("\n"))
    data.pop()
    data_fl = list(chain.from_iterable(data))
    len_data_fl = len(data_fl)
    num_v = len_data_fl/4
    v_id = data_fl[::4]
    v_lab = data_fl[1::4]
    v_lo = data_fl[2::4]
    v_hi = data_fl[3::4]
    cc = collections.Counter(v_lab)
    tmp = sorted(cc.items())
    return map(lambda x:x[1],tmp)

def plotZDD(G):
    data = map (lambda x:x.split(" "),G.dumps().strip().split("\n"))
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

Gg = makeZDD(randomHapCaseCont(20,20,20))
#plotZDD(G)

gg = graphZDD(Gg)

print(statZDD(Gg))

niter = 100
ncaco = 20
nmarker = 21
res = []
for i in range(niter):
    Gg = makeZDD(randomHap(nmarker,ncaco))
    res.append(statZDD(Gg))

means = map(lambda x:mean(x), res)
sums = map(lambda x:sum(x),res)

plt.hist(sums)
plt.show()


hapx = []
for i in range(nmarker):
    for j in range(ncaco):
        hapx.append([0]*ncaco)
        if i < ncaco:
            hapx[i][i] = 1

Gg = makeZDD(hapx)
sum(statZDD(Gg))

G = graphZDD(Gg)


degree_sequence=sorted(nx.degree(G).values(),reverse=True) # degree sequence
#print "Degree sequence", degree_sequence
dmax=max(degree_sequence)

plt.loglog(degree_sequence,'b-',marker='o')
plt.title("Degree rank plot")
plt.ylabel("degree")
plt.xlabel("rank")

# draw graph in inset
plt.axes([0.45,0.45,0.45,0.45])
Gcc=sorted(nx.connected_component_subgraphs(G), key = len, reverse=True)[0]
pos=nx.spring_layout(Gcc)
plt.axis('off')
nx.draw_networkx_nodes(Gcc,pos,node_size=20)
nx.draw_networkx_edges(Gcc,pos,alpha=0.4)

plt.savefig("degree_histogram.png")
plt.show()


Gg = makeZDD(randomHap(nmarker,ncaco))
G = graphZDD(Gg)

degree_sequence=sorted(nx.degree(G).values(),reverse=True) # degree sequence
print(degree_sequence)

#print "Degree sequence", degree_sequence
dmax=max(degree_sequence)

plt.loglog(degree_sequence,'b-',marker='o')
plt.title("Degree rank plot")
plt.ylabel("degree")
plt.xlabel("rank")

# draw graph in inset
plt.axes([0.45,0.45,0.45,0.45])
Gcc=sorted(nx.connected_component_subgraphs(G), key = len, reverse=True)[0]
pos=nx.spring_layout(Gcc)
plt.axis('off')
nx.draw_networkx_nodes(Gcc,pos,node_size=20)
nx.draw_networkx_edges(Gcc,pos,alpha=0.4)

plt.savefig("degree_histogram.png")
plt.show()
