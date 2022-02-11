# ----------------------------------------------------------------------------
# パロンドのパラドックスを乱数を使って確かめる
# (1) ゲームA/B/C それぞれの所持金比較
#  - gnuplot を利用するには以下のコマンドでインストールしておく必要がある
#    $ sudo apt-get install gnuplot-x11
#    $ gem install gnuplot
# ----------------------------------------------------------------------------
require "gnuplot"

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

all_results = []
a, b, c = [0, 0, 0]
trial_num = 100000
plot_num  = 1000
trial_num.times{|i|
  a += gameA()
  b += gameB(b)
  c += gameC(c)
  all_results.push( [ a, b, c ].clone ) if i % ( trial_num / plot_num ) == 0
}

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title  "パロンドのパラドックス(1) - ゲームA/B/C を各 10 万回試行した結果"
    plot.xlabel "試行回数"
    plot.ylabel "所持金"
    plot.set("key left top")
    plot.set("noxtics")
    plot.set("xzeroaxis")
    plot.data << Gnuplot::DataSet.new(all_results.transpose[0]){|ds|
      ds.with = "lines"
      ds.linewidth = 5
      ds.linecolor = 6
      ds.title = "ゲームA"
    }
    plot.data << Gnuplot::DataSet.new(all_results.transpose[1]){|ds|
      ds.with = "lines"
      ds.linewidth = 5
      ds.linecolor = 5
      ds.title = "ゲームB"
    }
    plot.data << Gnuplot::DataSet.new(all_results.transpose[2]){|ds|
      ds.with = "lines"
      ds.linewidth = 5
      ds.linecolor = 4
      ds.title = "ゲームC"
    }
  end
end
