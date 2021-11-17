# Project Euler Problem 67 Solver
# (c) Akihiro YOSHIDA
# 
# https://projecteuler.net/problem=67
#

data = File.read(ARGV[0]).split("\n").map{|e| e.split(" ").map{|ee| ee.to_i }}
cost = data.clone

cost.each_with_index{|line,y|
  next if y == 0
  line.each_with_index{|e,x|
    upper_left  = ( x == 0 ) ? nil : data[y-1][x-1] # 左端の場合、左上が存在しない
    upper_right = ( x == y ) ? nil : data[y-1][x]   # 右端の場合、右上が存在しない
    cost[y][x]  = e + [ upper_left, upper_right ].compact.max
  }
}

p cost[-1].max # 最終段の最大値
