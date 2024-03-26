defmodule AdventOfCode do
  def solve do
    File.read!("04.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      [[card_num], win_num, num] =
        String.split(s, ~r/[(?:Card):|]/, trim: true)
        |> Enum.map(fn c ->
          String.split(c, " ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)

      {card_num, win_num, num}
    end)
    |> parse_card(0)
    |> IO.inspect()
  end

  defp parse_card([], quantity), do: quantity

  defp parse_card([head | tail], quantity) do
    {card_num, win_num, num} = head

    match = find_match(num, win_num, 0)

    tail
    |> add_card(card_num, match)
    |> parse_card(quantity + 1)
  end

  defp add_card(cards, _, 0), do: cards
  defp add_card([], _, _), do: []

  defp add_card(cards, card_num, match) when match > 0 do
    added_card = cards |> List.keyfind(card_num + match, 0)
    add_card([added_card | cards], card_num, match - 1)
  end

  defp find_match([], _win_num, acc), do: acc

  defp find_match([head | tail], win_num, acc) do
    case head in win_num do
      true -> find_match(tail, win_num, acc + 1)
      false -> find_match(tail, win_num, acc)
    end
  end
end

AdventOfCode.solve()
