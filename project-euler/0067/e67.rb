# Project Euler Problem 67 Solver
# (c) Akihiro YOSHIDA
# 
# https://projecteuler.net/problem=67
#

a = File.read(ARGV[0]).split("\n").map{|e| e.split(" ").map{|ee| ee.to_i }}
s = a.clone

s.length.times{|i|
  next if i == 0
  s[i].length.times{|j|
    upper_left  = ( j == 0 ) ? nil : a[i-1][j-1] # 左端の場合、左上が存在しない
    upper_right = ( j == i ) ? nil : a[i-1][j]   # 右端の場合、右上が存在しない
    s[i][j] = a[i][j] + [ upper_left, upper_right ].compact.max
  }
}

p s[-1].max # 最終段の最大値
