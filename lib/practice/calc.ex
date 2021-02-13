defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  # %{
  #   "+" => 0,
  #   "-" => 0,
  #   "*" => 1,
  #   "/" => 1
  # }

  def tag_tokens(expr) do
    case expr do
      "*" -> {:op, expr}
      "/" -> {:op, expr}
      "-" -> {:op, expr}
      "+" -> {:op, expr}
      _ -> {:num, String.to_integer(expr)}
    end
  end

  def op_preference(op) do
    case op do
      {_, "*"} -> 2
      {_, "/"} -> 2
      {_, "-"} -> 1
      {_, "+"} -> 1
      {_, _} -> 0
    end
  end

  def push_to_op_stack(expr, result_queue, op_stack) do
    op = hd(expr)

    if op_stack === [] do
      convert_to_postfix(tl(expr), result_queue, [op])
    else
      cond do
        op_preference(op) > op_preference(hd(op_stack)) ->
          convert_to_postfix(tl(expr), result_queue, [op | op_stack])

        op_preference(op) === op_preference(hd(op_stack)) ->
          convert_to_postfix(tl(expr), result_queue ++ [hd(op_stack)], [op | tl(op_stack)])

        op_preference(op) < op_preference(hd(op_stack)) ->
          convert_to_postfix(tl(expr), result_queue ++ [hd(op_stack)], [op | tl(op_stack)])
      end
    end
  end

  def convert_to_postfix(expr, result_queue, op_stack) do
    if expr === [] do
      result_queue ++ op_stack
    else
      case hd(expr) do
        {:num, _} ->
          convert_to_postfix(tl(expr), result_queue ++ [hd(expr)], op_stack)

        {:op, _} ->
          push_to_op_stack(expr, result_queue, op_stack)
      end
    end
  end

  def eval(expr, result_stack) do
    if expr === [] do
      hd(result_stack)
    else
      case hd(expr) do
        {:num, _} ->
          eval(tl(expr), [elem(hd(expr), 1) | result_stack])

        {:op, _} ->
          tempOperand1 = hd(result_stack)
          tempOperand2 = hd(tl(result_stack))

          case elem(hd(expr), 1) do
            "*" ->
              val = tempOperand1 * tempOperand2
              eval(tl(expr), [ val | (tl (tl result_stack))])

            "/" ->
              val = div(tempOperand2, tempOperand1)
              eval(tl(expr), [val | (tl (tl result_stack))])

            "-" ->
              val = tempOperand2 - tempOperand1
              eval(tl(expr), [val | (tl (tl result_stack))])

            "+" ->
              val = tempOperand1 + tempOperand2
              eval(tl(expr), [ val | (tl (tl result_stack))])
          end
      end
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(fn x -> tag_tokens(x) end)
    |> convert_to_postfix([], [])
    |> eval([])
    # |> parse_float

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
