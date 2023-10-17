require './ast'

# 構文解析：Lexer が生成したトークンをもとに構文木を構築する
class Parser
  def initialize(lexer)
    @lexer = lexer
    @current_token = @lexer.get_next_token
  end

  # 現在のトークンが数値であればそれを返す
  def factor
    token = @current_token
    if @current_token[:type] == 'INTEGER'
      @current_token = @lexer.get_next_token
    else
      raise StandardError, 'Invalid syntax'
    end
    Num.new(token)
  end

  # 乗算・除算が現れる間呼ばれる
  def term
    node = factor

    while %w[* /].include? @current_token[:type]
      token = @current_token
      @current_token = @lexer.get_next_token
      node = BinOp.new(node, token, factor)
    end

    node
  end

  # 加算・減算が現れる間呼ばれる
  # 加数・減数として term メソッドを呼ぶことで、乗算・除算を先に行う
  def expression
    node = term

    while %w[+ -].include? @current_token[:type]
      token = @current_token
      @current_token = @lexer.get_next_token
      node = BinOp.new(node, token, term)
    end

    node
  end

  def eval
  tree = parse
  eval_ast(tree)
  end

  def eval_ast(node)
    if node.is_a?(BinOp)
      left_value = eval_ast(node.left)
      right_value = eval_ast(node.right)

      case node.operator[:type]
      when '+' then left_value + right_value
      when '-' then left_value - right_value
      when '*' then left_value * right_value
      when '/' then left_value / right_value
      else
        raise "Unknown operator: #{node.operator[:type]}"
      end
    elsif node.is_a?(Num)
      node.value
    else
      raise "Unknow AST node type: #{node.class}"
    end
  end

  def parse
    ast = expression
    if @current_token[:type] != 'EOF'
      error
    end
    ast
  end
end
