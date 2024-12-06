import Enum

defmodule Searcher do
  def search_line([a, b, c, d | mtx], acc) do
    if "#{[a, b, c, d]}" == "XMAS" or "#{[d, c, b, a]}" == "XMAS" do
      search_line([b, c, d] ++ mtx, acc + 1)
    else
      search_line([b, c, d] ++ mtx, acc)
    end
  end

  def search_line(l, acc) when length(l) < 4 do
    acc
  end

  def search_matrix([a | mtx], acc) do
    search_matrix(mtx, acc + search_line(a, 0))
  end

  def search_matrix([], acc) do
    acc
  end

  def matrix_at(mtx, row, col) do
    v = Enum.at(Enum.at(mtx, row), col)
    if v == nil do
      "-"
    else
      v
    end
  end

  def check_other_side(mtx, row_center, col_center) do
    str = "#{[
      (matrix_at mtx, row_center + 1, col_center - 1),
      (matrix_at mtx, row_center, col_center),
      (matrix_at mtx, row_center - 1, col_center + 1)
      ]}"
    str == "MAS" or str == "SAM"
  end

  def mas_searcher(mtx, row, col, stop, acc) when row < stop do
    # str = "#{map(0..2, fn i -> Enum.at(Enum.at(mtx, row + i), col + i) end)}"
    str = "#{[
      (matrix_at mtx, row, col),
      (matrix_at mtx, row + 1, col + 1),
      (matrix_at mtx, row + 2, col + 2)
      ]}"
    if str == "MAS" or str == "SAM" do
      if check_other_side(mtx, row + 1, col + 1) do
        mas_searcher(mtx, row + 1, col + 1, stop, acc + 1)
      else
        mas_searcher(mtx, row + 1, col + 1, stop, acc)
      end
    else
      mas_searcher(mtx, row + 1, col + 1, stop, acc)
    end
  end

  def mas_searcher(_, _, _, _, acc) do
    acc
  end

  def collect_mas(mtx) do
    # Enum.map(1..(length(mtx) - 3), fn i -> mas_searcher(mtx, i, 0, (length(mtx)-2), 0) end)
    Enum.sum(Enum.map(0..(length(mtx) - 3), fn i -> mas_searcher(mtx, 0, i, (length((hd mtx))-2), 0) end)) + Enum.sum(Enum.map(1..(length(mtx) - 3), fn i -> mas_searcher(mtx, i, 0, (length(mtx)-2), 0) end))
  end

end

defmodule IP do
  def diags_to_lines(mtx, col, row, stop) when col < stop and row < stop do
    [Enum.at(Enum.at(mtx, col), row)] ++ diags_to_lines(mtx, col + 1, row + 1, stop)
  end

  def diags_to_lines(_, _, _, _) do
    []
  end

  def collect_diags(mtx) do
    Enum.map(0..(length(mtx) - 1), fn i -> diags_to_lines(mtx, 0, i, length(mtx)) end) ++
      Enum.map(1..(length(mtx) - 1), fn i -> diags_to_lines(mtx, i, 0, length(mtx)) end)
  end

  def filter_diags(diags) do
    Enum.filter(diags, fn l -> length(l) >= 4 end)
  end

  def matrix_reverse(mtx) do
    Enum.map(mtx, fn l -> Enum.reverse(l) end)
  end

  def matrix_transpose(mtx) do
    Enum.zip_with(mtx, &Function.identity/1)
  end

  def to_matrix(s) do
    String.split(s, "\n")
    |> map(fn line -> String.graphemes(line) end)
  end

  def count_all(mtx) do
    [
      Searcher.search_matrix(mtx, 0),
      matrix_transpose(mtx) |> Searcher.search_matrix(0),
      collect_diags(mtx) |> filter_diags |> Searcher.search_matrix(0),
      matrix_reverse(mtx) |> collect_diags |> filter_diags |> Searcher.search_matrix(0)
    ]
    |> Enum.sum()
  end

  def parse(filename) do
    File.read!(filename)
    |> to_matrix
    |> count_all
  end
end

defmodule IP2 do
  def parse(filename) do
    File.read!(filename)
    |> IP.to_matrix
    |> Searcher.collect_mas
  end
end
