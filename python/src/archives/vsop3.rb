$LOAD_PATH.push("/home/satoshi/.gem/ruby/2.2.0/lib/nysol")
require "zdd"

#下記のようなハプロタイプを考えます
#a=011110000
#b=001111000
#c=000111100
#nysolではuniverseの定義は必ずしも必要でない
#x=ZDD::itemset("1 2 3 4 5 6 7 8 9 10")
a=ZDD::itemset("2 3 4 5")
b=ZDD::itemset("3 4 5 6")
c=ZDD::itemset("4 5 6 7")

#ZDDも配列に格納できる
arr = [a,b,c]
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

#亜集合行列のようなものができる
print subsets[0], "\n"
print subsets[1], "\n"
print subsets[2], "\n"
