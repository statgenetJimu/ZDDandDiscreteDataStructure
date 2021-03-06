# -*- coding: utf-8 -*-


from graphillion import GraphSet
import graphillion.tutorial as tl
n=15
m=10
nm = n+m
goal = (n+1)*(m+1)

universe=tl.grid(n,m)
GraphSet.set_universe(universe)

Gt=GraphSet.paths(1,goal)
Gs=Gt.graph_size(nm)

Guniv = GraphSet({})
Gss = Guniv.graph_size(nm)
Gs2 = Gss.paths(1,goal)

len(Gs)
len(Gs2)

