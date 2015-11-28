from graphillion import GraphSet
import graphillion.tutorial as tl
n=3
m=2
nm = n+m
goal = (n+1)*(m+1)

universe=tl.grid(n,m)
GraphSet.set_universe(universe)

Gt=GraphSet.paths(1,goal)

Gs=Gt.graph_size(nm)
example = Gs.choice()
example = (Gs.including(5)).choice()

print len(Gs)
print example
tl.draw(example)
