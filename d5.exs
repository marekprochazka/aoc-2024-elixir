import Enum, only: [reverse: 1, map: 2, any?: 2, uniq: 1]
import String, only: [split: 2, to_integer: 1]

defmodule BubbleSort do
  def sort(l, rls) do
    sort(l, [], rls)
  end

  defp must_swap?(a,b, rules) do
    any?(rules, fn {b_r, a_r} -> a == a_r and b == b_r end)
  end

  defp sort(l, acc, rls) when length(l) > 0 do
    [x | xs] = reverse(pass(l, rls))
    sort(reverse(xs), [x] ++ acc, rls)
  end

  defp sort([], acc, _) do
    acc
  end

  defp pass([a, b | l], rls) do
    if must_swap?(a,b, rls) do
      [b] ++ pass([a | l], rls)
    else
      [a] ++ pass([b | l], rls)
    end
  end

  defp pass([a], _) do
    [a]
  end

  defp pass([], _) do
    []
  end
end

defmodule IP do
  def parse_rules(f) do
    File.read!(f)
    |> split("\n")
    |> map(&String.split(&1, "|"))
    |> map(fn [a, b] -> {(to_integer a), (to_integer b)} end)
  end

  def parse_input(f) do
    File.read!(f)
    |> split("\n")
    |> map(fn l -> map(split(l, ","), fn v -> to_integer(v) end) end)
  end

  def filter_unsorted(mtx, rules) do
    Enum.filter(mtx, fn l -> BubbleSort.sort(l, rules) == l end)
  end

  def filter_sorted(mtx, rules) do
    Enum.filter(mtx, fn l -> BubbleSort.sort(l, rules) != l end)
    |> map(fn l -> BubbleSort.sort(l, rules) end)
  end

  defp get_middle_element(l) do
    Enum.at(l, div(length(l), 2))
  end

  def mid_sum(mtx) do
    Enum.sum(map(mtx, &get_middle_element/1))
  end

  def main(f_rules, f_input) do
    rules = parse_rules(f_rules)
    mtx = parse_input(f_input)
    unsorted = filter_unsorted(mtx, rules)
    sorted = filter_sorted(mtx, rules)
    ms1 = mid_sum(unsorted)
    ms2 = mid_sum(sorted)
    {ms1, ms2}
  end
end
