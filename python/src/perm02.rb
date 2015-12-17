require 'statsample'
require 'zdd'
require 'matrix'

ngene=1000
rand=Statsample::Shorthand::rnorm(200,100,20)
haps=rand.map{|item| (14..(ngene+4)).to_a.sample(item)}

camark=(1..100).map{(4...14).to_a.sample(6)}
comark=(1..100).map{(4...14).to_a.sample(2)}
items = Array.new

for i in 0...100 do
   items[i]= [2, camark[i], haps[i]]
   items[i+100]= [3, comark[i], haps[i+100]]
end

haps=ZDD::itemset("")

for i in 0...200 do
    haps=haps+ZDD::itemset(items[i].join(" "))
end


two=ZDD::itemset("2")
three=ZDD::itemset("3")

ca=haps.restrict("2")/two
co=haps.restrict("3")/three
puts ca.freqpatA(20) - co.freqpatM(20)

#rubyでは重み計算はできないようである
