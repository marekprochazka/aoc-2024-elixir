defmodule IP do
  defp format(l) do
    {String.to_integer(Enum.at(l, 0)), String.split(Enum.at(l,1), " ", trim: true) |> Enum.map(&String.to_integer/1)}
  end

  def parse(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(&format/1)
  end
end

defmodule NumUtils do
  def digit_len(n) do
    n
    |> Integer.to_string
    |> String.length
  end

  def d_concat(a, b) do
    a * 10 ** digit_len(b) + b
  end
end

defmodule Main do
  def equation_rec([x | xs], acc, target) do
    Enum.any?([
      equation_rec(xs, acc + x, target),
      equation_rec(xs, acc * x, target),
      equation_rec(xs, NumUtils.d_concat(acc, x), target)
    ])
  end

  def equation_rec([], acc, target) do
    acc == target
  end

  def main do
    IP.parse("d7")
    |> Enum.filter(fn {target, terms} -> equation_rec((tl terms), (hd terms), target) end)
    |> Enum.reduce(0, fn {target, _}, acc -> acc + target end)
  end
end
