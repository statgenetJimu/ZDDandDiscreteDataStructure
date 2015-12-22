# -*- coding: utf-8 -*-


from graphillion import GraphSet
import graphillion.tutorial as tl
n=6
m=6
nm = n+m
goal = (n+1)*(m+1)

universe=tl.grid(n,m)
GraphSet.set_universe(universe)

Gt=GraphSet.paths(1,goal)
Gs=Gt.graph_size(nm)

Guniv = GraphSet({})

GsS  = Guniv.graph_size(nm)
GsSP = GsS.paths(1,goal)
print len(GsS)
print len(GsSP)
Gss = []
GsSP = []


GsP  = Guniv.paths(1,goal)
GsPS = GsP.graph_size(nm)
print len(GsP)
print len(GsPS)


