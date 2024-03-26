defmodule AdventOfCode do
  def solve do
    File.read!("02.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&find_power/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  @colors ["red", "green", "blue"]
  defp find_power(line) do
    @colors
    |> Enum.map(&find_required_cubes(&1, line))
    |> Enum.product()
  end

  defp find_required_cubes(color, line) do
    Regex.scan(~r/\d+\s#{color}/, line)
    |> List.flatten()
    |> Enum.map(&String.replace_trailing(&1, " #{color}", ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.max()
  end
end

AdventOfCode.solve()
