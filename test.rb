require './lib/infer'

defn = File.read('./tapl/3-1-booleans.txt')
tree = Infer::Parser.parse(defn)

p tree
