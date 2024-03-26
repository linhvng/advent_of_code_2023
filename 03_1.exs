defmodule AdventOfCode do
  @schematic File.read!("03.txt") |> String.split("\n", trim: true)
  def solve do
    @schematic
    |> Enum.map(&extract_parts_in_line/1)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp extract_parts_in_line(line) do
    line_index = @schematic |> Enum.find_index(fn x -> x == line end)

    valid_parts_coordinate =
      Regex.scan(~r/\d+/, line, return: :index)
      |> List.flatten()
      |> Enum.filter(&is_parts_valid(&1, line_index))

    valid_parts_coordinate
    |> Enum.map(fn {x, l} -> String.slice(line, x, l) end)
  end

  defp is_parts_valid({x, l}, y) do
    # find_adjacent_coordinate, then check for symbols
    -1..l
    |> Enum.into([], fn l ->
      [
        {max(x + l, 0), max(y - 1, 0)},
        {max(x + l, 0), y},
        {max(x + l, 0), y + 1}
      ]
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.any?(&check_symbol/1)
  end

  defp check_symbol({x, y}) do
    @schematic
    |> Enum.at(y, "")
    |> String.at(x)
    |> (fn c -> unless is_nil(c), do: Regex.match?(~r/[^[:alnum:]\.]/, c) end).()
  end
end

AdventOfCode.solve()
