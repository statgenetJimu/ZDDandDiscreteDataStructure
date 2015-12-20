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
#ハプロタイプデータでのケース・コントロールのデータの表示
#ケースで多いx4~x13が多く見られている
#これが有意かどうか判定するために、パーミュテーションする
puts (pcase-pcont.restrict(pcase))

#パーミュテーション回数100回
niter=100

#トランザクションファイルの作り方はほぼ一緒
permutation = Array.new
for j in 0..niter do
    perms=Array.new
    permph=(1..200).map{[2,3].sample(1)}
    for i in 0..100 do
        perms[i]=[permph[i],camark[i],haps[i]].join(" ")
        perms[i+100]=[permph[i],comark[i],haps[i]].join(" ")
    end

    File.open("permdata/perm.txt","w") do |file|
        perms.each do |line|
            file.write(line +"\n")
        end
    end

    perm=ZDD::lcm("MQ","permdata/perm.txt",40,"permdata/order.txt")
    permcase=perm.restrict(ca)/ca
    permcont=perm.restrict(co)/co
    permutation[j]=(pcase-permcase.restrict(pcase)).hashout.to_a
end

#配列にケースからパーミュテーションあとのケースを引き算した係数を収納
val = Array.new
for i in 0..niter do
    key=[permutation[0][1][0]]
    val[i]=permutation[i][1][1]
end

#とりあえずtop motifのみ表示
#あとは検定するだけ・・・
#パーミュテーション後にはほとんどモチーフは見られない
#パーミュテーション後の最小サポート閾値を小さくしても良いかもしれない

puts key 
puts "mean", val.mean
puts "SD", val.sd
