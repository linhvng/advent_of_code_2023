defmodule AdventOfCode do
  def solve do
    File.read!("04.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp parse_card(card) do
    [win_num, num] =
      card
      |> String.splitter(":", trim: true)
      |> Enum.take(-1)
      |> List.first()
      |> String.split("|")
      |> Enum.map(fn s ->
        String.splitter(s, " ", trim: true) |> Enum.take_every(1)
      end)

    find_match(num, win_num, 0) |> calculate_point()
  end

  defp find_match([head | tail], win_num, acc) do
    case head in win_num do
      true -> find_match(tail, win_num, acc + 1)
      false -> find_match(tail, win_num, acc)
    end
  end

  defp find_match([], _win_num, acc), do: acc

  defp calculate_point(num_of_matches) do
    case num_of_matches > 1 do
      true -> 2 ** (num_of_matches - 1)
      _ -> num_of_matches
    end
  end
end

AdventOfCode.solve()
