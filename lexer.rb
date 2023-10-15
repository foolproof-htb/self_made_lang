# 字句解析：コードをトークンに分割する
class Lexer
  def initialize(input)
    @input = input
    @position = 0
    @current_char = @input[@position]
  end

  def advance
    @position += 1
    @current_char = @position < @input.length ? @input[@position] : nil
  end

  def skip_whitespace
    advance while @current_char =~ /\s/
  end

  def integer
    result = ''
    while @current_char =~ /\d/
      result += @current_char
      advance
    end
    result.to_i
  end

  def get_next_token
    while !@current_char.nil?
      case @current_char
      when /\s/
        skip_whitespace
        next
      when /[0-9]/
        return {type: 'INTEGER', value: integer}
      when '+', '-', '*', '/'
        operater = @current_char
        advance
        return {type: operater, value: operater}
      end

      advance
    end
    {type: 'EOF', value: nil}
  end
end
