require 'statsample'
require 'zdd'
require 'matrix'

test=ZDD::lcm("FQ","trans.txt",40,"order.txt")

#トランザクションファイルを配列の形式で読み込み、
#フェノタイプをシャッフルし、
#新たなトランザクションファイルを作り、
#一旦書き出し、lcmで読み込む
#
#パーミュテーション回数100回
niter=100

permutationZDD=Array.new
permutation=Array.new
for j in 0...niter do
	
	trans=Array.new
	permph=Array.new
	File.open("trans.txt") do |file|
		file.each_line.with_index do |lines, index|
			trans[index]=lines.split()
			permph[index]=trans[index][0]
		end
	end

	permph.shuffle!
	
	perms=Array.new
	trans.each.with_index do |item, index|
		item[0]=permph[index]
		perms[index]=item.join(" ")
	end
	
	File.open("perm.txt", "w") {|file|
		perms.each{|line|
			file.write(line+"\n")
		}
	}

	permutationZDD[j]=ZDD::lcm("FQ", "perm.txt", 40, "order.txt")
end


ca=ZDD::itemset("x2")
tes=test.restrict(ca)/ca
per=permutationZDD[0].restrict(ca)/ca
print tes, "\n"
print per.restrict(tes)


tmp=Array.new
tab=Array.new
for i in 0..(permutation.length-1) do
	tab[i] = Array.new
	for j in permutation[i] do
		tmp = j.split(" x")[0]
		tab[i].push(tmp)
	end
end

tab2=Array.new
for i in 0..(refcase.length-2) do
	tmp = Array.new
	for j in tab do
		tmp.push(j[i])
	end
	tab2[i]=tmp
end

print "観測値:permutationでの最大値\n"
tab2.each_with_index do |item, index|
	key =refcase[index].split(" ")[0].to_i
	print index, ":", key, "    :", key - item.min.to_i, "\n"
end

