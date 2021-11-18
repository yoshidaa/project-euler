# Project Euler Problem 18 Solver
# (c) Akihiro YOSHIDA
# 
# https://projecteuler.net/problem=18
#

data = File.read(ARGV[0]).split("\n").map{|e| e.split(" ").map{|ee| ee.to_i }}
# [[3], [7, 4], [2, 4, 6], [8, 5, 9, 3]]

num = data.length - 1
sum = lambda{|arr| arr.inject(:+) }

all = (0..2**num-1).map{|i|
  route = (0..num-1).map{|idx| i[idx] }.reverse
  xidxs = [0] + (0..num-1).map{|idx| sum[route[0..idx]] }
  vals  = xidxs.each_with_index.map{|x,y| data[y][x] }
  sum[vals]
}

p all.max # ŠeŒo˜H‚Ì˜a‚ÌÅ‘å’l
