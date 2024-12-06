

defmodule IP do
    @tiles [
        {:empty, "."},
        {:visited, "X"},
        {:wall, "#"},
        {:player_north, "^"},
        {:player_south, "v"},
        {:player_west, "<"},
        {:player_east, ">"}
    ]


    defp tile_to_atom(tile) do
        Enum.find(@tiles, fn {_, t} -> t == tile end)
        |> elem(0)
    end

    defp next_direction(:player_north), do: :player_east
    defp next_direction(:player_east), do: :player_south
    defp next_direction(:player_south), do: :player_west
    defp next_direction(:player_west), do: :player_north


    defp get_player_position(map) do
        {x, y} = for {row, y} <- Enum.with_index(map), {tile, x} <- Enum.with_index(row), tile in [:player_north, :player_south, :player_west, :player_east], do: {x, y}
        {x, y}
    end

    def parse_input(filename) do
        File.read!(filename)
        |> String.split("\n")
        |> Enum.map(&String.split(&1, "", trim: true))
        |> Enum.map(&Enum.map(&1, fn tile -> tile_to_atom(tile) end))
        |> get_player_position
    end

end
