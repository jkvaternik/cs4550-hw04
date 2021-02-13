defmodule Practice.Factor do
  def find_factors(num) do
    fact = 3..(num)
    |> Enum.find(num, fn x -> rem(num, x) == 0 end)
    fact
  end

  def factor(1) do
    []
  end

  def factor(num) when rem(num, 2) === 0 do
    [2 | factor(div(num, 2))]
  end

  def factor(num) do
    fact = find_factors(num)
    [fact | factor(div(num, fact))]
  end
end
