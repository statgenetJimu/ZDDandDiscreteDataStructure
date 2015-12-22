require "zdd"

#vsop6_1.Rで作成されたtranfファイルから一行ずつ読み込み全体の集合を作る
pall = ZDD::itemset("")
File.open('trans.txt') do |file|
	file.each_line do |line|
		line.chomp!
		pall = pall + ZDD::itemset(line)
	end
end

#ヘッダ情報をもとにcaseとcontrolを分ける
ca = ZDD::itemset("2")
co = ZDD::itemset("3")

#ヘッダ情報の除去
pcase = pall.restrict("2")/ca
pcont = pall.restrict("3")/co

#最小サポートに応じてcaseから頻出パターンを抽出
pat = pcase.freqpatA(10)
counts = Array.new

#取り出した頻出パターンそれぞれについて2x2表作成のためのベクトルを作成
pat.each{|item|
	a = pcase.restrict(item).count
	b = pcase.count - a
	c = pcont.restrict(item).count
	d = pcont.count - c
	arr = item.to_a
	comb = arr.join(",")
	counts.push([a,b,c,d,comb])
}

#正確性検定をrubyで実装するのが大変なのでCSVで書き出しvsop6_2.Rで処理
require 'csv'
CSV.open("counts.csv","w") do |csv|
	counts.each do |item|
		csv << item
	end
end
