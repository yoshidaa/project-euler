require "./lib/darts_board"
require "optparse"
require "gnuplot"

if $0 == __FILE__
  verbose = false

  opt = OptionParser.new
  opt.on( "-v", "--verbose", "文字などを入れるモード" ){|v| verbose = true }
  opt.parse!(ARGV)

  basename = File.basename(__FILE__,".*")
  filename = verbose ? basename + "-verbose.png" : basename + ".png"

  board = DartsBoard.new("soft")

  results = []

  brateps = (1..99).to_a
  brateps.map{|bratep|
    brate  = bratep.to_f / 100
    single = board.landing_prob( brate, "OS20" ) * 100
    double = board.landing_prob( brate, "D20" ) * 100
    triple = board.landing_prob( brate, "T20" ) * 100
    results.push( [ single, double, triple, bratep ] )
  }

  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      if verbose
        plot.title  "「ブル率」と「各エリアを狙って入れられる確率」の関係"
        plot.xlabel "ブル率(%)"
        plot.ylabel "狙って入れられる確率(%)"
        plot.set("xtics (10,20,30,40,50,60,70,80,90)")
      else
        plot.set("noxtics")
      end
      plot.set("term pngcairo size 1280, 800 font 'Arial,20'")
      plot.set("output '#{filename}'")
      plot.set("key left top")
      plot.set("grid ytics")
      plot.set("xrange [1:99]")
      plot.data << Gnuplot::DataSet.new(results.transpose[0]){|ds|
        ds.with = "lines"
        ds.linewidth = 5
        ds.linecolor = "rgb '#296FBC'"
        ds.title = "シングル"
      }
      plot.data << Gnuplot::DataSet.new(results.transpose[1]){|ds|
        ds.with = "lines"
        ds.linewidth = 5
        ds.linecolor = "rgb '#CB360D'"
        ds.title = "ダブル"
      }
      plot.data << Gnuplot::DataSet.new(results.transpose[2]){|ds|
        ds.with = "lines"
        ds.linewidth = 5
        ds.linecolor = "rgb '#3D9435'"
        ds.title = "トリプル"
      }
      plot.data << Gnuplot::DataSet.new(results.transpose[3]){|ds|
        ds.with = "lines dt (10,5)"
        ds.linewidth = 5
        ds.linecolor = "rgb '#999999'"
        ds.title = "ブル"
      }
    end
  end
end
