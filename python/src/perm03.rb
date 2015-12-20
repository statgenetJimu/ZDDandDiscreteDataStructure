require 'statsample'
require 'zdd'
require 'matrix'

#マーカー数1000個、一人あたりのSNVの数は平均が100でSD20の正規分布
#フェノタイプはケースが2、コントロールが3と表現する
#1が空集合として使われることがあるため
#フェノタイプ, ケースで多いマーカー(10個), 背景のマーカーを繋ぐ

ngene=1000
rand=Statsample::Shorthand::rnorm(200,100,20)
haps=rand.map{|item| (14..(ngene+4)).to_a.sample(item)}

camark=(1..100).map{(4...14).to_a.sample(6)}
comark=(1..100).map{(4...14).to_a.sample(1)}
items = Array.new

for i in 0...100 do
   items[i]= [2, camark[i], haps[i]].join(" ")
   items[i+100]= [3, comark[i], haps[i+100]].join(" ")
end

#トランザクションファイルの書き出し
File.open("permdata/haps.txt", "w") do |file|
     items.each do |line|
        file.write(line +"\n")
     end
end

#オーダーファイルの書き出し
torder=ngene+4
order=Array(1..torder).join(" ")
File.open("permdata/order.txt", "w") do |file|
     file.write(order)
end

#ハプロタイプデータを読み込み、ZDDを作成
test=ZDD::lcm("FQ","permdata/haps.txt",40,"permdata/order.txt")

ca=ZDD::itemset("x2")
co=ZDD::itemset("x3")
pcase=test.restrict(ca)/ca
pcont=test.restrict(co)/co
puts (pcase-pcont.restrict(pcase))

#lcm-FQで作成された頻出パターンをテキスト形式で書き出し
outpcase=pcase.to_s
outpcont=pcont.to_s
File.open("permdata/FQ.txt", "w") do |file|
	file.write(outpcase + "\n")
	file.write(outpcont + "\n")
end
