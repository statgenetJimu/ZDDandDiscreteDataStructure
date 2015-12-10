require "zdd"
require "matrix"
require "benchmark"

result = Benchmark.realtime do

def meets(arr)
    arr[0].meet(arr[1])
end

#ハプロタイプを重複なく集めるために二進法からの変換で文字列を作る
#ハプロタイプ数は2^nとなる
n=12

#あとで桁数を0で埋めるための宣言
dim = "%0#{n}d"

#二進法表記の各ハプロタイプベクトルにかけてアイテム表現にするための数列ベクトル
#ZDD作成の際に何故かアイテム番号が逆になるのでここで先に逆にしておく
#最後のmeetメソッドでは空集合は１として表されるためアイテムは２から始まることにする
seq = ((2..n+1).to_a).reverse

#collect2メソッドでベクトルが要求されるので型変換
seq = Vector.elements(seq)

#まず10進数で配列を用意
arr = (1..(2**n)-1)

#二進法に変換
bin = arr.map{|item| item.to_s(2)}

#ゼロパウンディング
tmp = bin.map{|item| format(dim, item)}

#一旦配列に分割
tmp = tmp.map{|item| item.split("")}

#ベクトルそれぞれの要素を掛け算
tmp = tmp.map{|item| seq.collect2(item.map(&:to_i)){|x,y| x*y}}

#０を除去
tmp = tmp.map{|item| item.reject{|e| e==0}}

#スペースを間に入れて結合
tmp = tmp.map{|item| item.join(" ")}

#ZDDに変換
zdds = tmp.map{|item| ZDD::itemset(item)}

#直積から共通集合を求める
prod = zdds.product(zdds).map{|item| meets(item)}

#空集合は１と表現される
#print "ZDD\n", zdds, "\n"
#print "共通集合の集まり", prod, "\n"

end

print "処理時間 #{result}秒\n"
