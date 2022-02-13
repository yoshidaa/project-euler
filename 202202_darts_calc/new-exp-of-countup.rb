require "./lib/darts_board"
require "optparse"
require "gnuplot"

if $0 == __FILE__
  verbose = false
  scoreonly = false

  opt = OptionParser.new
  opt.on( "-v", "--verbose",  "文字などを入れるモード" ){|v| verbose = true }
  opt.on( "-s", "--scoreonly","スコアのみ" ){|v| scoreonly = true }
  opt.parse!(ARGV)

  basename = File.basename(__FILE__,".*")
  filename = verbose ? basename + "-verbose.png" : basename + ".png"

  filename = filename.sub(".png","-scoreonly.png") if scoreonly

  board = DartsBoard.new("soft")

  bratep_to = 50

  results = []
  (1..bratep_to).each{|bratep|
    bull_rate        = bratep.to_f / 100
    # 1投あたりの期待値

    center           = board.center("DB")
    is_prob          = board.landing_prob( bull_rate, "IS20", center )
    os_prob          = board.landing_prob( bull_rate, "OS20", center )
    t_prob           = board.landing_prob( bull_rate, "T20", center )
    d_prob           = board.landing_prob( bull_rate, "D20", center )

    sum_of_numbers   = (1..20).inject(:+)

    bull_exp         = bull_rate * 50 * 24
    is_exp           = is_prob    * sum_of_numbers * 24
    os_exp           = os_prob    * sum_of_numbers * 24
    d_exp            = d_prob * 2 * sum_of_numbers * 24
    t_exp            = t_prob * 3 * sum_of_numbers * 24

    legacy_exp       = ( 50 * bull_rate + 10.5 * ( 1 - bull_rate ) ) * 24
    propose_exp      = bull_exp + is_exp + t_exp + os_exp + d_exp

    if scoreonly
      results.push( [ bratep, legacy_exp, propose_exp ] )
    else
      results.push( [ bratep, legacy_exp, propose_exp, bull_exp + is_exp + os_exp + d_exp, bull_exp + is_exp + os_exp, bull_exp + is_exp, bull_exp ] )
    end
  }

  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      if verbose
        plot.title  "ブル率別のカウントアップ期待値"
        plot.xlabel "ブル率(%)"
        plot.ylabel "期待値"
        plot.set("xtics 5")
      else
        plot.set("noxtics")
      end
      plot.set("term pngcairo size 1280, 800 font 'Arial,20'")
      plot.set("output '#{filename}'")
      plot.set("key left top")
      plot.set("grid ytics")
      plot.set("xrange [1:#{bratep_to}]")
      if scoreonly
        plot.data << Gnuplot::DataSet.new(results.transpose[1]){|ds|
          ds.with = "lines"
          ds.linewidth = 5
          ds.linecolor = "rgb '#296FBC'"
          ds.title = "従来法"
        }
        plot.data << Gnuplot::DataSet.new(results.transpose[2]){|ds|
          ds.with = "lines"
          ds.linewidth = 5
          ds.linecolor = "rgb '#CB360D'"
          ds.title = "全領域キャッチ法"
        }
      else
        plot.data << Gnuplot::DataSet.new(results.transpose[2]){|ds|
          ds.with = " filledcurves x1"
          ds.linecolor = "rgb '#7386A4'"
          ds.title = "トリプル"
        }
        plot.data << Gnuplot::DataSet.new(results.transpose[3]){|ds|
          ds.with = " filledcurves x1"
          ds.linecolor = "rgb '#9ECBAB'"
          ds.title = "ダブル"
        }
        plot.data << Gnuplot::DataSet.new(results.transpose[4]){|ds|
          ds.with = " filledcurves x1"
          ds.linecolor = "rgb '#D2E0AC'"
          ds.title = "アウターシングル"
        }
        plot.data << Gnuplot::DataSet.new(results.transpose[5]){|ds|
          ds.with = " filledcurves x1"
          ds.linecolor = "rgb '#FFF4D9'"
          ds.title = "インナーシングル"
        }
        plot.data << Gnuplot::DataSet.new(results.transpose[6]){|ds|
          ds.with = " filledcurves x1"
          ds.linecolor = "rgb '#F7CAC8'"
          ds.title = "ブル"
        }
        plot.data << Gnuplot::DataSet.new(results.transpose[1]){|ds|
          ds.with = "lines"
          ds.linewidth = 6
          ds.linecolor = "rgb '#FF0000'"
          ds.title = "従来法"
        }
      end
    end
  end
end
