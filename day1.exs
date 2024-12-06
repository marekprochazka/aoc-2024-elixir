defmodule InputParser do
  def parseInput do
    File.read!("d1")
    |> String.split("\n")
  end

  def leftList do
    parseInput()
    |> Enum.map(&(hd &1 |> String.split(" ", trim: true)))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort(&<=/2)
  end

  def rightList do
    parseInput()
    |> Enum.map(&(hd tl &1 |> String.split(" ", trim: true)))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort(&<=/2)
  end
end

defmodule Processor do
  def merge_dist(l1, l2) do
    Enum.zip(l1, l2)
    |> Enum.map(fn {x, y} -> Kernel.abs(x - y) end)
  end

  def sum(l) do
    Enum.reduce(l, 0, &+/2)
  end

  def appearence_list(l_source, l_definitive) do
      Enum.map(l_source, fn x -> {x, Enum.count(l_definitive, &(&1 == x))} end)
  end

  def merge_multiplication(l) do
    Enum.map(l, fn {a, b} -> a * b end)
  end
end
