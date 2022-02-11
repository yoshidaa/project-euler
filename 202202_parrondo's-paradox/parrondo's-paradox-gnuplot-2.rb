# ----------------------------------------------------------------------------
# パロンドのパラドックスを乱数を使って確かめる
# (2) ゲームBで所持金が 3 の倍数以外の確率を変えたときのゲームB試行結果
#  - gnuplot を利用するには以下のコマンドでインストールしておく必要がある
#    $ sudo apt-get install gnuplot-x11
#    $ gem install gnuplot
# ----------------------------------------------------------------------------
require "gnuplot"

# ゲームA: 48% の確率で +1$、52% の確率で -1$
def gameA
  rand() <= 0.48 ? 1 : -1
end

# ゲームB: 所持金が 3 の倍数なら       1% の確率で +1$、99% の確率で -1$
#          所持金が 3 の倍数以外なら prob の確率で +1$、15% の確率で -1$
def gameB( pos, prob )
  ( ( pos % 3 ) == 0 ) ? ( rand() <= 0.01 ? 1 : -1 )
                       : ( rand() <= prob ? 1 : -1 )
end

# ゲームC: 50%の確率でゲームA・ゲームBのどちらかを行う
def gameC( pos, prob )
  rand() <= 0.5 ? gameA() : gameB(pos, prob)
end

all_results = []
trial_num = 100000
(1..99).each{|prob_percent|
  b = 0
  prob = prob_percent.to_f / 100
  trial_num.times{|i|
    b += gameB(b,prob)
  }
  all_results.push(b)
}

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title  "パロンドのパラドックス(2) - ゲームBで所持金が 3 の倍数でない確率を変えたときのゲームB試行結果"
    plot.xlabel "ゲームBで所持金が 3 の倍数でない場合の勝率(%)"
    plot.ylabel "所持金"
    plot.set("key left top")
    plot.set("xzeroaxis")
    plot.data << Gnuplot::DataSet.new(all_results){|ds|
      ds.with = "lines"
      ds.linewidth = 5
      ds.linecolor = 5
      ds.title = "ゲームB"
    }
  end
end
