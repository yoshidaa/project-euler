#
# 01_simple.rb
#
def fibonacci_simple( n )
  case n
  when 0, 1
    return n
  else
    return fibonacci_simple( n - 1 ) + fibonacci_simple( n - 2 )
  end
end

if $0 == __FILE__
  p fibonacci_simple( ARGV[0].to_i )
end
