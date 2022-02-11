# ゲームA: 48% の確率で +1$、52% の確率で -1$
def gameA
  rand() <= 0.48 ? 1 : -1
end

# ゲームB: 所持金が 3 の倍数なら      1% の確率で +1$、99% の確率で -1$
#          所持金が 3 の倍数以外なら 85% の確率で +1$、15% の確率で -1$
def gameB( pos )
  ( ( pos % 3 ) == 0 ) ? ( rand() <= 0.01 ? 1 : -1 )
                       : ( rand() <= 0.85 ? 1 : -1 )
end

# ゲームC: 50%の確率でゲームA・ゲームBのどちらかを行う
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
