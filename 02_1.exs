defmodule AdventOfCode do
  @valid_cubes %{
    :red => 12,
    :green => 13,
    :blue => 14
  }

  def solve do
    File.read!("02.txt")
    |> String.split("\n", trim: true)
    |> Enum.filter(&is_game_valid/1)
    |> Enum.map(&get_game_number/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp is_game_valid(line) do
    max_result = find_max_result(line)
    max_cube_color = find_max_cubes(line, max_result)
    @valid_cubes[max_cube_color] >= max_result
  end

  defp find_max_cubes(line, max_result) do
    Regex.run(~r/#{max_result}\s\w+/, line)
    |> List.first()
    |> String.split()
    |> List.last()
    |> String.to_atom()
  end

  defp find_max_result(line) do
    line
    |> String.split(":")
    |> List.last()
    |> (&Regex.scan(~r/\d+/, &1)).()
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.max()
  end

  defp get_game_number(line) do
    line
    |> String.split(":")
    |> List.first()
    |> String.replace("Game ", "")
    |> String.to_integer()
  end
end

AdventOfCode.solve()
