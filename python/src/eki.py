#!/usr/bin/env python
# coding: utf-8

import networkx as nx
import csv
import matplotlib.pylab as plt

names={}
codes={}
lines={}
gps={}

path="."
csvfile=open("stations.csv")
for row in csv.reader(csvfile):
	gc=row[0]
	name=row[1].decode('utf-8')
	names[gc]    = name
	codes[name]  = gc
	lines[gc]    = row[2].decode('utf-8')
	gps[gc]= [float(row[3]),float(row[4])]
csvfile.close()

def ekiHelp():
	print """\
getRoute 辺リストで与えられた経路を始点から終点の順に並べた頂点リストに変換する
書式) getRoute(path, mode=1, start=None):
引数) path: 経路を構成する辺リスト
      mode: 頂点名の種別 1:駅コード(デフォルト), 2:駅名, 3:駅コード+駅名
      start: 始点駅コード(指定しなければ、出力される頂点リストの先頭は不定)

ekiPlot  路線図を描画する
書式) ekiPlot(univ, path=None, mode=2, start=None, k=0.05, iterations=50, node_size=300, ewidth=5):
引数) univ: Graphillionに与えたユニバース(リスト型)
      phath: 強調表示する経路(辺リスト),省略すれば経路表示はせずユニバースのみ表示する
      mode:節点ラベル表示, 0:表示しない,1:駅コードを表示,2:駅名を表示,3:駅コード+駅名を表示
      start: 始点駅コード(指定しなければ、経路の両端のどちらが開始駅として表示されるかは不定)
      以下はnetworkxの各関数に渡されるパラメータ
      k: 最適な節点間距離,spring_layout関数のk=パラメータ
      iterations: バネモデルにおける繰り返し回数,spring_layout関数のnode_size=パラメータ
      node_size: 節点の大きさ,draw関数のnode_size=パラメータ
      ewidth: 経路の強調表示おける線の幅,draw_networkx_edges関数のwidth=パラメータ

sumWeight  経路の重みを合計する
書式) sumWeight(path,weights=None)
  path: 経路を構成する辺リスト
  weights: 辺をkeyとする重み(辞書型)
           省略すると全ての辺を1.0として計算する(すなわちlen(path)に同じ)。
"""

# pathの枝の重み合計を計算する。
def sumWeight(path,weights=None):
	sum=0.0
	if weights==None:
		for edge in path:
			sum+=1.0
	else:
		for edge in path:
			if edge in weights:
				sum+=weights[edge]
			else:
				sum+=1.0
	return sum

def getRoute(path, mode=1, start=None):
	# node=>[nodes]のmapを登録
	node2nodes={}
	for edge in path:
		n0=edge[0]
		n1=edge[1]
		if n0 in node2nodes:
			node2nodes[n0].append(n1)
		else:
			node2nodes[n0]=[n1]
		if n1 in node2nodes:
			node2nodes[n1].append(n0)
		else:
			node2nodes[n1]=[n0]

	terminals=[]
	for x in node2nodes:
		if len(node2nodes[x])==1:
			terminals.append(x)
	if start==None:
		start=terminals[0]
		goal=terminals[1]
	else:
		if start==terminals[0]:
			goal=terminals[1]
		else:
			goal=terminals[0]

	route=[]
	node=start
	while True:
		# node登録
		route.append(node)

		# 終了判定
		if node==goal:
			break

		# 次の接続nodeを得る
		nodes=node2nodes[node]
		if nodes[0] not in route:
			node=nodes[0]
		elif nodes[1] not in route:
			node=nodes[1]
		else:
			print "error: not a single path."
			exit()

	ret=[]
	if   mode==1:
		ret=route
	elif mode==2:
		for stCD in route:
			ret.append(names[stCD])
	elif mode==3:
		for stCD in route:
			ret.append("%s(%s)" % (names[stCD],stCD))

	return ret

def ekiPlot(univ, path=None, mode=2, k=0.05, iterations=50, node_size=300, start=None, ewidth=5):
	g=nx.Graph()
	g.add_edges_from(univ)

	if path:
		route=getRoute(path)
		if start==None:
			start=route[0]
			goal=route[-1]
		else:
			if start==route[0]:
				goal=route[-1]
			else:
				goal=route[0]

	nodes=[]
	labels={}
	for x in g.nodes():
		label=""
		if   mode==1:
			label=x
		elif mode==2:
			label=names[x]
		elif mode==3:
			label="%s(%s)" % (names[x],x)

		if path and x==start:
			nodes.append('yellow')
			labels[x]="START\n"+label
		elif path and x==goal:
			nodes.append('yellow')
			labels[x]="GOAL\n"+label
		else:
			nodes.append('white')
			labels[x]=label

	pos=nx.spring_layout(g,pos=gps,k=k,iterations=iterations)
	nx.draw(g,pos,node_color=nodes, node_size=node_size)
	if path:
		nx.draw_networkx_edges(g,pos,width=ewidth,edgelist=path,edge_color='red')
	nx.draw_networkx_labels(g, pos, labels, font_size = 12, font_family = 'sans-serif', font_color = 'k')
	#plt.savefig("g.eps")
	plt.show()

