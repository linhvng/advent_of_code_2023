defmodule AdventOfCode do
  def solve do
    File.read!("04.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      [[id], win_num, num] =
        String.split(s, ~r/[(?:Card):|]/, trim: true)
        |> Enum.map(fn c ->
          String.split(c, " ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)

      {id, win_num, num, 1}
    end)
    |> parse_card
    |> Enum.sum()
    |> IO.inspect()
  end

  defp parse_card([]), do: []

  defp parse_card([head | tail]) do
    {_id, win_num, num, quantity} = head

    matches = find_match(num, win_num, 0)

    added_cards = add_card(tail, quantity, matches)
    [quantity | parse_card(added_cards)]
  end

  defp add_card(cards, _total_quantity, 0), do: cards
  defp add_card([], _total_quantity, _), do: []

  @doc """
  kudos to bjorn (core erlang contributor) for the add_card function.
  https://github.com/bjorng/advent-of-code-2023/blob/main/day04/lib/day04.ex

  his solution is similar to mine, but it don't need to find card by index
  just need to add the quantity to the next one (head of the tail...)
  """
  defp add_card([{id, win_num, num, quantity} | tail], total_quantity, matches) do
    added_card = {id, win_num, num, quantity + total_quantity}
    [added_card | add_card(tail, total_quantity, matches - 1)]
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
