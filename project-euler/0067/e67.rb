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
    upper_left  = ( j == 0 ) ? nil : a[i-1][j-1] # ���[�̏ꍇ�A���オ���݂��Ȃ�
    upper_right = ( j == i ) ? nil : a[i-1][j]   # �E�[�̏ꍇ�A�E�オ���݂��Ȃ�
    s[i][j] = a[i][j] + [ upper_left, upper_right ].compact.max
  }
}

p s[-1].max # �ŏI�i�̍ő�l
