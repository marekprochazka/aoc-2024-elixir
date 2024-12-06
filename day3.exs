import Enum, only: [map: 2]

defmodule IP do
  @regex ~r/mul\([0-9]+,[0-9]+\)/
  @regex_num ~r/[0-9]+/
  def transform(l) do
    map(l, fn x -> String.split(x, ",") end)
    |> map(fn [a, b] -> {hd(hd(Regex.scan(@regex_num, a))), hd(hd(Regex.scan(@regex_num, b)))} end)
    |> map(fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end)
  end

  def process(l) do
    transform(l)
    |> Enum.reduce(0, fn {a, b}, acc -> acc + a * b end)
  end

  def parse(filename) do
    File.read!(filename)
    |> (&Regex.scan(@regex, &1)).()
    |> map(&hd/1)
    |> process
  end
end

defmodule IP2 do
  @regex ~r/mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\)/
  @regex_num ~r/[0-9]+/

  def process_mul_string(s) do
    [a, b] = String.split(s, ",")

    String.to_integer(hd(hd(Regex.scan(@regex_num, a)))) *
      String.to_integer(hd(hd(Regex.scan(@regex_num, b))))
  end

  def repl_with_atoms(l) do
    map(l, fn v ->
      case v do
        x when x == "do()" -> {:do, nil}
        x when x == "don't()" -> {:dont, nil}
        x -> {:mul, process_mul_string(x)}
      end
    end)
  end

  def eval_expression([x | xs], active, acc) do
    case x do
      {:mul, v} ->
        if active,
          do: eval_expression(xs, active, acc + v),
          else: eval_expression(xs, active, acc)

      {:do, _} ->
        eval_expression(xs, true, acc)

      {:dont, _} ->
        eval_expression(xs, false, acc)
    end
  end

  def eval_expression([], _, acc) do
    acc
  end

  def parse(filename) do
    File.read!(filename)
    |> (&Regex.scan(@regex, &1)).()
    |> map(&hd/1)
    |> repl_with_atoms
    |> eval_expression(true, 0)
  end
end
