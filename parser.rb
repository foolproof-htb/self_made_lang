# 構文解析：Lexer が生成したトークンをもとに構文木を構築する
class Parser
  def initialize(lexer)
    @lexer = lexer
    @current_token = @lexer.get_next_token
  end

  def error
    raise StandardError, 'Invalid syntax'
  end

  # 現在のトークンが期待される指定トークンと一致しているか確認する
  def eat(token_type)
    if @current_token[:type] == token_type
      @current_token = @lexer.get_next_token
    else
      error
    end
  end

  # 現在のトークンが数値であればそれを返す
  def factor
    token = @current_token
    eat('INTEGER')
    token[:value]
  end

  # 乗算・除算が現れる間呼ばれる
  def term
    result = factor

    while %w[* /].include? @current_token[:type]
      token = @current_token
      @current_token = @lexer.get_next_token
      if token[:type] == '*'
        result *= factor
      elsif token[:type] == '/'
        result /= factor
      end
    end

    result
  end

  # 加算・減算が現れる間呼ばれる
  # 加数・減数として term メソッドを呼ぶことで、乗算・除算を先に行う
  # ただし現状では加減算のあとの乗除算は判断できない
  def expression
    result = term

    while %w[+ -].include? @current_token[:type]
      token = @current_token
      @current_token = @lexer.get_next_token
      if token[:type] == '+'
        result += term
      elsif token[:token] == '/'
        result -= term
      end
    end

    result
  end

  def parse
    expression
  end
end
