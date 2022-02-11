# �Q�[��A: 48% �̊m���� +1$�A52% �̊m���� -1$
def gameA
  rand() <= 0.48 ? 1 : -1
end

# �Q�[��B: �������� 3 �̔{���Ȃ�      1% �̊m���� +1$�A99% �̊m���� -1$
#          �������� 3 �̔{���ȊO�Ȃ� 85% �̊m���� +1$�A15% �̊m���� -1$
def gameB( pos )
  ( ( pos % 3 ) == 0 ) ? ( rand() <= 0.01 ? 1 : -1 )
                       : ( rand() <= 0.85 ? 1 : -1 )
end

# �Q�[��C: 50%�̊m���ŃQ�[��A�E�Q�[��B�̂ǂ��炩���s��
def gameC( pos )
  rand() <= 0.5 ? gameA() : gameB(pos)
end

a, b, c = [0, 0, 0]
trial_num = 100000
trial_num.times{|i|
  a += gameA()
  b += gameB(b)
  c += gameC(c)
}

p [ a, b, c ]
