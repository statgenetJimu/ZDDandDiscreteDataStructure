require 'zdd'

orderf="order.txt"
q=30
method="FQ"

transf="trans.txt"
tall=ZDD::lcm(method,transf,q,orderf)
pall=ZDD::lcm(method,"perm4.txt",q,orderf)


caseHead=ZDD::itemset("x2")
contHead=ZDD::itemset("x3")

tcase=tall.restrict(caseHead)/caseHead
tcont=tall.restrict(contHead)/contHead

pcase=pall.restrict(caseHead)/caseHead
pcont=pall.restrict(contHead)/contHead

test = tcase-tcont
perm = pcase-pcont

puts test-perm
