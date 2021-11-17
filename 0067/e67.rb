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
    upper_left  = ( x == 0 ) ? nil : data[y-1][x-1] # ���[�̏ꍇ�A���オ���݂��Ȃ�
    upper_right = ( x == y ) ? nil : data[y-1][x]   # �E�[�̏ꍇ�A�E�オ���݂��Ȃ�
    cost[y][x]  = e + [ upper_left, upper_right ].compact.max
  }
}

p cost[-1].max # �ŏI�i�̍ő�l
