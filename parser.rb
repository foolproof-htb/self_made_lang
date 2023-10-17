require './ast'

# 構文解析：Lexer が生成したトークンをもとに構文木を構築する
class Parser
  def initialize(lexer)
    @lexer = lexer
    @current_token = @lexer.next_token
  end

  def eval
    tree = parse
    eval_ast(tree)
  end

  private

  def parse
    ast = expression
    syntax_error if @current_token[:type] != 'EOF'
    ast
  end

  # 式のノードを返す
  # 加数・減数として term メソッドを呼ぶことで、乗算・除算を先に行う
  def expression
    node = term

    while %w[+ -].include? @current_token[:type]
      token = @current_token
      @current_token = @lexer.next_token
      node = BinOp.new(node, token, term)
    end

    node
  end

  # 乗算・除算のノードを生成して返す
  def term
    node = factor

    while %w[* /].include? @current_token[:type]
      token = @current_token
      @current_token = @lexer.next_token
      node = BinOp.new(node, token, factor)
    end

    node
  end

  # 数値のノードを生成して返す
  def factor
    token = @current_token
    syntax_error unless @current_token[:type] == 'INTEGER'

    @current_token = @lexer.next_token
    Num.new(token)
  end

  def syntax_error
    raise StandardError, 'Invalid syntax'
  end

  # 構文木に沿って式を実行する
  def eval_ast(node)
    case node
    when BinOp
      eval_bin_op(node)
    when Num
      node.value
    else
      raise "Unknow AST node type: #{node.class}"
    end
  end

  def eval_bin_op(node)
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
  end
end
