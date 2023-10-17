require './lexer'
require './parser'

# 式を受け取って計算する
class Calculator
  def evaluate(expression)
    lexer = Lexer.new(expression)
    parser = Parser.new(lexer)
    parser.eval
  end
end
