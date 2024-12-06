defmodule IP do
  def parse(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn v -> Enum.map(v, &String.to_integer/1) end)
  end
end

defmodule Utils do
  def drop_at_index(list, index) do
    list
    |> Enum.with_index()
    |> Enum.reject(fn {_value, i} -> i == index end)
    |> Enum.map(fn {value, _i} -> value end)
  end
end

defmodule Analyzer do
  def safe_r?([_], _), do: []
  def safe_r?([], _), do: []

  def safe_r?([head, next | tail], predicate) do
    [predicate.(head, next)] ++ safe_r?([next | tail], predicate)
  end

  def safe?(list, predicate) do
    Enum.all?(safe_r?(list, predicate), fn v -> v end)
  end

  def each_with_skipps(list, predicate, indx) do
    if Enum.count(list) == indx do
      []
    else
      [safe_r?(Utils.drop_at_index(list, indx), predicate)] ++
        each_with_skipps(list, predicate, indx + 1)
    end
  end

  def safe_with_toleration?(list, predicate) do
    if Enum.all?(safe_r?(list, predicate), fn v -> v end) do
      true
    else
      Enum.any?(each_with_skipps(list, predicate, 1), fn v -> Enum.all?(v, fn v -> v end) end)
    end
  end
end

defmodule Main do
  def predicate_inc(a, b) do
    a < b and 1 <= Kernel.abs(a - b) and Kernel.abs(a - b) <= 3
  end

  def predicate_dec(a, b) do
    a > b and 1 <= Kernel.abs(a - b) and Kernel.abs(a - b) <= 3
  end

  def main do
    IP.parse("d2")
    |> Enum.map(fn v ->
      Analyzer.safe?(v, &predicate_inc/2) or Analyzer.safe?(v, &predicate_dec/2)
    end)
    |> Enum.filter(fn v -> v end)
    |> Enum.count()
  end

  def main_part_2 do
    IP.parse("d2")
    |> Enum.map(fn v ->
      Analyzer.safe_with_toleration?(v, &predicate_inc/2) or
        Analyzer.safe_with_toleration?(v, &predicate_dec/2)
    end)
    |> Enum.filter(fn v -> v end)
    |> Enum.count()
  end
end
