require "zdd"
require "matrix"

#下記のようなハプロタイプを考える
#meetでは空集合が１とされるので、マーカーは２から始まることとする
#a=1111000000
#b=0111100000
#c=0011110000
#d=0001111000
#e=0000111100
#f=0000011110
#g=0000001111
#h=1000000111
#i=1100000011
a=ZDD::itemset("2 3 4 5")
b=ZDD::itemset("3 4 5 6")
c=ZDD::itemset("4 5 6 7")
d=ZDD::itemset("5 6 7 8")
e=ZDD::itemset("6 7 8 9")
f=ZDD::itemset("7 8 9 10")
g=ZDD::itemset("8 9 10 11")
h=ZDD::itemset("2 9 10 11")
i=ZDD::itemset("2 3 10 11")

#ループでやる場合
arr = [a,b,c,d,e,f,g,h,i]
j = 0
i = 0
subsets = Array.new(arr.length)
arr.each{|item|
    subgroup = Array.new(arr.length)
    i = 0
    arr.each{|item2|
        subgroup[i] = item.meet(item2)
        i += 1
    }
    subsets[j] = subgroup
    j += 1
}

#print subsets


#直積で組み合わせを作れば下のようにもできる
#直積から直接投げられそうだがうまく行かなかったので関数を定義する
def meets(arr)
    arr[0].meet(arr[1])
end
print arr.product(arr).map {|item| meets(item)}

