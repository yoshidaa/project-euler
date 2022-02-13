require "json"

module DartsMath

  R = 22

  def self.sigma( soft_brate )
    brate = (soft_brate >= 1) ? soft_brate.to_f / 100 : soft_brate
    sigma = R * Math.sqrt( - 1.0 / ( 2 * Math.log( 1 - brate ) ) )
  end

  def self.prob_density( r, t, ar, at, sx, sy )
    ax = ar * Math.cos(at)
    ay = ar * Math.sin(at)
    x  = r * Math.cos(t)
    y  = r * Math.sin(t)
    prob = 1.0 / ( 2 * Math::PI * sx * sy ) * Math.exp( - ( ( x - ax ) ** 2 / ( 2 * sx ** 2 ) + ( y - ay ) ** 2 / ( 2 * sy ** 2 ) ) )
  end

  def self.prob_cumulative( r0, r1, t0, t1, ar, at, sx, sy, num_dr=100, num_dt=100 )
    r0, r1 = [ r0, r1 ].sort
    t0, t1 = [ t0, t1 ].sort

    dr = (r1-r0).to_f / num_dr
    dt = (t1-t0).to_f / num_dt

    prob = 0
    num_dr.times{|nr|
      r  = r0 + ( dr * ( 2 * nr + 1 ) / 2 )
      dS = r * dr * dt # with Jacobian
      num_dt.times{|nt|
        t = t0 + ( dt * ( 2 * nt + 1 ) / 2 )
        prob += prob_density( r, t, ar, at, sx, sy ) * dS
      }
    }

    prob
  end
end
