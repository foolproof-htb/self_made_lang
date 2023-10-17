# 字句解析：コードをトークンに分割する
class Lexer
  def initialize(input)
    @input = input
    @position = 0
    @current_char = @input[@position]
  end

  # rubocop:disable Metrics/MethodLength
  def next_token
    until @current_char.nil?
      case @current_char
      when /\s/
        skip_whitespace
        next
      when /[0-9]/
        return { type: 'INTEGER', value: integer }
      when '+', '-', '*', '/'
        return { type: operator, value: operator }
      end
      advance
    end
    { type: 'EOF', value: nil }
  end
  # rubocop:enable Metrics/MethodLength

  private

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

  def operator
    operator = @current_char
    advance
    operator
  end

  def advance
    @position += 1
    @current_char = @position < @input.length ? @input[@position] : nil
  end
end
