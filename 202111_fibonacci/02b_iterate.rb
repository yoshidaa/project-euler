#
# 02b_iterate.rb
#
def fibonacci_iterate( n )
  n1 = 0; n2 = 1

  (n-1).times{
    n1, n2 = [ n2, n1 + n2 ]
  }

  n == 0 ? 0 : n2
end

if $0 == __FILE__
  p fibonacci_iterate( ARGV[0].to_i )
end
