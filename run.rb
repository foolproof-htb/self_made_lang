require './calculator'

expression = ARGV[0]
calc = Calculator.new
result = calc.evaluate(expression)
puts "result: #{result}"
