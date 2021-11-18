#
# 03_binet.rb
#
def fibonacci_general( n )
  r5 = Math.sqrt(5)
  ((((1 + r5) * 0.5) ** n - ((1 - r5) * 0.5) ** n) / r5).round
end

if $0 == __FILE__
  p fibonacci_general( ARGV[0].to_i )
end
