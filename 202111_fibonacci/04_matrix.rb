#
# 04_matrix.rb
#
require 'matrix'

def fibonacci_matrix( n )
  base   = Matrix[[1, 1], [1, 0]]
  result = base ** n
  result[0,1]
end

if $0 == __FILE__
  p fibonacci_matrix( ARGV[0].to_i )
end
