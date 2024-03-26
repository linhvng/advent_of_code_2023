defmodule AdventOfCode do
  @schematic File.read!("03.txt") |> String.split("\n", trim: true)
  def solve do
    @schematic
    |> Enum.map(&find_gears_in_line/1)
    |> List.flatten()
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_gears_in_line(line) do
    line_index = @schematic |> Enum.find_index(fn x -> x == line end)

    Regex.scan(~r/\*/, line, return: :index)
    |> List.flatten()
    |> Enum.map(&find_valid_gears_power(&1, line_index))
  end

  defp find_valid_gears_power({x, _l}, y) do
    # find_adjacent_coordinate, then check for valid parts
    # then find the power of gear, return 0 if invalid
    surround_coord = [
      {max(x - 1, 0), max(y - 1, 0)},
      {max(x - 1, 0), y},
      {max(x - 1, 0), y + 1},
      {x, max(y - 1, 0)},
      {x, y + 1},
      {x + 1, max(y - 1, 0)},
      {x + 1, y},
      {x + 1, y + 1}
    ]

    parts =
      surround_coord
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.filter(&get_parts_coord/1)
      |> Enum.map(&get_parts/1)
      |> Enum.uniq()
      |> Enum.map(fn p -> Kernel.elem(p, 0) |> String.to_integer() end)

    if Kernel.length(parts) === 2, do: parts |> Enum.product(), else: 0
  end

  defp get_parts_coord({gear_x, gear_y}) do
    @schematic
    |> Enum.at(gear_y)
    |> String.at(gear_x)
    |> (fn s -> s != "." end).()
  end

  defp get_parts({x, y}) do
    [{part_start, part_length}] =
      @schematic
      |> Enum.at(y)
      |> (&Regex.scan(~r/\d+/, &1, return: :index)).()
      |> List.flatten()
      |> Enum.filter(fn {start, length} -> x >= start and x < start + length end)

    part_number =
      @schematic
      |> Enum.at(y)
      |> String.slice(part_start, part_length)

    {part_number, {part_start, part_length, y}}
  end
end

AdventOfCode.solve()
