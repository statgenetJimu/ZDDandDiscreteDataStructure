require 'zdd'
require 'matrix'

#ハプロタイプデータをlcmFQで読み込み、ZDDを作成
test=ZDD::lcm("FQ","trans.txt",40,"order.txt")
ca=ZDD::itemset("x2")
co=ZDD::itemset("x3")

pcase=test.restrict(ca)/ca
pcont=test.restrict(co)/co

#lcm-FQで作成された頻出パターンをテキスト形式で書き出し
outpcase=pcase.to_s
File.open("permdata/FQca.txt", "w") do |file|
	file.write(outpcase)
end

outpcont=pcont.to_s
File.open("permdata/FQco.txt", "w") do |file|
	file.write(outpcont)
end

#ハプロタイプデータをlcmMQで読み込み、ZDDを作成
test=ZDD::lcm("MQ","permdata/haps.txt",50,"permdata/order.txt")

pcase=test.restrict(ca)/ca
pcont=test.restrict(co)/co

#lcm-MQで作成された頻出パターンをテキスト形式で書き出し
outpcase=pcase.to_s
File.open("permdata/MQca.txt", "w") do |file|
	file.write(outpcase)
end

outpcont=pcont.to_s
File.open("permdata/MQco.txt", "w") do |file|
	file.write(outpcont)
end

