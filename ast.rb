# 構文木
class AST
  attr_reader :token

  def initialize(token)
    @token = token
  end
end

class BinOp < AST
  attr_reader :left, :operator, :right

  def initialize(left, operator, right)
    super(operator)
    @left = left
    @operator = operator
    @right = right
  end
end

class Num < AST
  attr_reader :value

  def initialize(token)
    super(token)
    @value = token[:value]
  end
end
