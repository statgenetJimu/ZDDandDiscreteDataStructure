$LOAD_PATH.push("/home/ryamada/.gem/ruby/2.2.0/gems/zdd-1.0.0-linux/lib/nysol/")
require 'zdd'

p = ZDD::lcm("FQ","trans.txt",50,"order.txt")
pdiff = ZDD::lcm("FQ","trans_diff.txt",30,"order.txt")

puts p.count
puts pdiff.count
