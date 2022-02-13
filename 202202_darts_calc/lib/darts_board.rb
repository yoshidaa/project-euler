require "pp"
require_relative "./darts_math"

class DartsBoard
  R          = 22 # (mm)
  HALF_ANGLE = 2 * Math::PI / 40 # (radian)

  def initialize( board_type="soft" )
    @numbers    = [ 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20, 1, 18, 4, 13 ]

    # 中心の角度
    # (x,y) で右下方向を正とし、(反ではなく)時計回りにθをとる
    @angles     = Hash[ @numbers.map.with_index{|n,i| [ n, i.to_f * 2 * HALF_ANGLE ] } ]

    @board_type = board_type.downcase
    @areas = { "center"      => "C",
               "inner_bull"  => "DB",
               "outer_bull"  => "SB",
               "inner_single"=> "IS",
               "triple"      => "T",
               "outer_single"=> "OS",
               "double"      => "D",
               "miss"        => "MISS" }
    if board_type.downcase == "soft"
      @radiuses = { "center"      =>   0,
                    "inner_bull"  =>   8.5,
                    "outer_bull"  =>   R,
                    "inner_single"=> 105,
                    "triple"      => 123,
                    "outer_single"=> 176,
                    "double"      => 195,
                    "miss"        => 999 }
    else # steel darts board
      @radiuses = { "center"      =>   0,
                    "inner_bull"  =>   6.35,
                    "outer_bull"  =>  15.9,
                    "inner_single"=>  99,
                    "triple"      => 107,
                    "outer_single"=> 162,
                    "double"      => 170,
                    "miss"        => 999 }
    end
  end

  attr_reader :numbers, :radiuses

  # 角度 (ラジアン) からナンバーを求める
  def number_from_angle( rad )
    @angles.each{|number,t|
      dot = ( Math.cos(t) * Math.cos(rad) + Math.sin(t) * Math.sin(rad) )
      return number if dot >= Math.cos( HALF_ANGLE )
    }
  end

  # 半径 (mm) からエリアの種類 (DB,SB,IS,T,OS,D,MISS) を求める
  def areatype_from_radius( r )
    @radiuses.keys.each_cons(2){|f,t|
      return @areas[t] if ( @radiuses[f] <= r ) && ( r < @radiuses[t] )
    }
  end

  # エリア名から半径の範囲を求める
  def radius_range( area )
    if area == "BULL"
      [ @radiuses.values[0], @radiuses.values[0] ]
    else
      type = ( area == "DB" || area == "SB" ) ? area : area[0..-3]
      idx = @areas.values.index(type)
      @radiuses.values[(idx-1)..(idx)]
    end
  end

  # エリア名から半径の中心値を求める
  def center_radius( area )
    radius = nil
    if area == "DB" || area == "SB" || area == "BULL"
      radius = 0 # all angles is ok
    else
      radius = radius_range( area ).inject(:+).to_f / 2
    end

    radius
  end

  # エリア名から角度の範囲を求める
  def angle_range( area )
    if area == "DB" || area == "SB" || area == "BULL"
      angle0 = 0
      angle1 = 2 * Math::PI
    else
      number  = area[-2..-1].to_i
      angle0 = @angles[number] - HALF_ANGLE
      angle1 = @angles[number] + HALF_ANGLE
    end
    [ angle0, angle1 ]
  end

  # エリア名から半径の中心値を求める
  def center_angle( area )
    angle = nil
    if area == "DB" || area == "SB" || area == "BULL"
      angle = 0 # all angles is ok
    else
      number = area[-2..-1].to_i
      angle = @angles[number]
    end

    angle
  end

  # エリア名から角度と半径それぞれの中心値を求める
  def center( area )
    { "radius"=>center_radius( area ), "angle"=>center_angle( area ) }
  end

  # 半径と角度からエリア名を求める
  def area( dart )
    number   = number_from_angle( dart["theta"] )
    areatype = areatype_from_radius( dart["radius"] )
    area     = ( areatype == "DB" || areatype == "SB" || areatype == "MISS" ) ? areatype : areatype + "%02d" % number

    area
  end

  # ソフトのブル率 s_brate に対して area を狙って入る確率
  # optional で任意の aim = { "radius"=>xx, "angle"=>yy } を指定可能
  def landing_prob( s_brate, area, aim=nil )
    aim  ||= center(area)
    r0, r1 = radius_range(area)
    t0, t1 = angle_range(area)
    sigma  = DartsMath.sigma( s_brate )

    prob   = DartsMath.prob_cumulative( r0, r1, t0, t1, aim["radius"], aim["angle"], sigma, sigma )

    prob
  end
end


if $0 == __FILE__
  d = DartsBoard.new("hard")

  if false
    [ 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20, 1, 18, 4, 13 ].each{|n|
      [ "IS", "T", "OS", "D" ].each{|a|
        target = sprintf("%s%02d", a, n )
        p [ target, d.center_position( target ) ]
      }
    }
  elsif false
    0.step(6.28, 0.1){|rad|
      p [ "%.2f" % rad, rad * 360 / ( 2 * Math::PI ), d.number_from_angle( rad ) ]
    }
  elsif true
    [ 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20, 1, 18, 4, 13 ].each{|n|
      [ "OS" ].each{|a|
        target = sprintf("%s%02d", a, n )
        p [ target, d.angle_range( target ), d.center_angle( target ) ]
      }
    }
  end
end
