require 'statsample'
require 'zdd'
require 'matrix'

class Array
    def avg
        (inject(0.0){|r,i| r+=i.to_i}/size).round(1)
    end

    def variance
        a=avg
        inject(0.0){|r,i| r+=(i.to_i-a)**2}/size
    end

    def standard_deviation
        (Math.sqrt(variance)).round(1)
    end
end



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
for j in 0...niter do
    perms=Array.new
    permph=(1..200).map{[2,3].sample(1)}
    for i in 0..100 do
        perms[i]=[permph[i],camark[i],haps[i]].join(" ")
        perms[i+100]=[permph[i+100],comark[i],haps[i+100]].join(" ")
    end

    File.open("permdata/perm.txt","w") do |file|
        perms.each do |line|
            file.write(line +"\n")
        end
    end

    perm=ZDD::lcm("FQ","permdata/perm.txt",30,"permdata/order.txt")
    permcase=perm.restrict(ca)/ca
    permcont=perm.restrict(co)/co
    permutation[j]=(pcase-permcase.restrict(pcase)).to_a
    refcase=pcase.to_a
end

#配列にケースからパーミュテーションあとのケースを引き算した係数を収納
tmp=Array.new
tab=Array.new
for i in 0.. (permutation.length-1) do
    tab[i]=Array.new
    for j in permutation[i] do
        tmp=j.split(" x")[0]
        tab[i].push(tmp)
    end
end

tab2=Array.new
for i in 0..(refcase.length-2) do
    tmp=Array.new
    for j in tab do
        tmp.push(j[i])
    end
    tab2[i]=tmp
end

print "観測値:Permutaionでの最大値\n"
tab2.each_with_index do |item, i|
    if item != nil then 
        key = refcase[i].split(" ")[0].to_i
        print key, "    :",  key - item.min.to_i, "\n"
    end
end


