#coding: UTF-8:
from graphillion import GraphSet
import graphillion.tutorial as tl
from random import seed
import math
import networkx as nx


def grid_prob(m, n=None, p=0.5, q=0.5, prob_to_remove_edge=0.0):
    assert 0 <= prob_to_remove_edge and prob_to_remove_edge < 0.4
    seed(1)
    m += 1
    if n is None:
        n = m
    else:
        n += 1
    edges = []
    for v in range(1, m*n+1):
        if v % n != 0:
            edges.append((v, v+1, p))
        if v <= (m-1)*n:
            edges.append((v, v+n, q))
    return edges

def prob_dict(grid_prob):
    weight = {}
    key = () 
    for i in grid_prob:
        weight[(i[0], i[1])]=float(i[2])
    return weight

def sumWeight(path, weights):
    sum=0.0
    for edge in path:
        if edge in weights:
            sum += weights[edge]
        else:
            sum += 1.0
    return sum

#m列n行の格子を左上から右下にあるくこととする
#下に移動する可能性をp,下に向かう可能性をqとする

m = 2 
n = 2
p = 0.2
q = 0.8

lp = math.log10(p)
lq = math.log10(q)
mn = m+n 
goal = (m+1)*(n+1)

universe= grid_prob(m, n, p=lp, q=lq)
GraphSet.set_universe(universe)

Gu = GraphSet({})
Gt = Gu.graph_size(mn)
Gs = Gt.paths(1, goal)
weight = prob_dict(universe)

for i in Gs.max_iter(weight):
    wt = sumWeight(i, weight)
    print 10**wt
    print i


