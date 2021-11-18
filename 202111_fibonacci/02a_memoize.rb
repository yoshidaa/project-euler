#
# 02a_memoize.rb
#
@memo = [ 0, 1 ]
def fibonacci_memoize( n )
  @memo[n] ||= fibonacci_memoize( n - 1 ) + fibonacci_memoize( n - 2 )
end

if $0 == __FILE__
  p fibonacci_memoize( ARGV[0].to_i )
end
