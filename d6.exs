

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
        l = for {row, y} <- Enum.with_index(map), {tile, x} <- Enum.with_index(row), tile in [:player_north, :player_south, :player_west, :player_east], do: {x, y}
        hd l
    end

    def parse_input(filename) do
        File.read!(filename)
        |> String.split("\n")
        |> Enum.map(&String.split(&1, "", trim: true))
        |> Enum.map(&Enum.map(&1, fn tile -> tile_to_atom(tile) end))
        |> fn map -> {map, get_player_position(map)} end.()
    end

    def get_tile_in_front(map, player_position) do
        {x, y} = player_position
        direction = map |> Enum.at(y) |> Enum.at(x)
        {new_x, new_y} = get_new_xy(player_position, direction)
        if xy_in_range?(map, new_x, new_y) do
            map |> Enum.at(new_y) |> Enum.at(new_x)
        else
            :out_of_bounds
        end
    end

    def get_next_move(map, player_position) do
        tile_in_front = get_tile_in_front(map, player_position)
        case tile_in_front do
            v when v in [:empty, :visited] -> :move
            :wall -> :turn
            :out_of_bounds -> :stop
        end
    end

    def get_new_xy(player_position, direction) do
        {x, y} = player_position
        case direction do
            :player_north -> {x, y-1}
            :player_south -> {x, y+1}
            :player_west -> {x-1, y}
            :player_east -> {x+1, y}
        end
    end

    def xy_in_range?(map, x, y) do
        x >= 0 && y >= 0 && y < Enum.count(map) && x < Enum.count(Enum.at(map, 0))
    end

    def move(map, player_position, :OK) do
        {x, y} = player_position
        direction = map |> Enum.at(y) |> Enum.at(x)
        {new_x, new_y} = get_new_xy(player_position, direction)

        next_move = get_next_move(map, player_position)

        case next_move do
            :stop -> List.replace_at(map, y, List.replace_at(Enum.at(map, y), x, :visited)) |> move(player_position, :OUT_OF_BOUNDS)
            :turn -> List.replace_at(map, y, List.replace_at(Enum.at(map, y), x, next_direction(direction))) |> move({x,y}, :OK)
            :move -> List.replace_at(map, y, List.replace_at(Enum.at(map, y), x, :visited)) |> (fn new_map -> List.replace_at(new_map, new_y, List.replace_at(Enum.at(new_map, new_y), new_x, direction)) end).() |> move({new_x, new_y}, :OK)
        end
    end

    def move(map, _, :OUT_OF_BOUNDS) do
        map
    end

    def sum_visited(map) do
        map |> Enum.reduce(0, fn row, acc -> acc + Enum.count(Enum.filter(row, fn tile -> tile == :visited end)) end)
    end

    def main(filename) do
        {map, player_position} = parse_input(filename)
        move(map, player_position, :OK) |> sum_visited
    end


end
