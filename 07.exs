defmodule AdventOfCode do
  def solve do
    parse_input("07.txt")
    # |> part_2()
    |> part_1(&find_type/1)
    |> IO.inspect(charlists: :as_list)
  end

  defp part_1(hands, type) do
    hands
    |> Enum.sort_by(fn %{cards: cards, bet: _} ->
      {type.(cards), cards}
    end)
    |> Enum.with_index(1)
    |> Enum.map(fn {hand, rank} -> hand.bet * rank end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Enum.map(fn %{cards: cards, bet: bet} ->
      %{
        cards:
          Enum.map(cards, fn
            11 -> 1
            s -> s
          end),
        bet: bet
      }
    end)
    |> part_1(&find_type_2/1)
  end

  defp find_type(cards) do
    find_type(Enum.sort(cards), :"0_high")
  end

  defp find_type([c, c, c, c, c], _), do: :"6_five_kind"
  defp find_type([c, c, c, c | _], _), do: :"5_four_kind"
  defp find_type([c, c, c | _], :"1_pair"), do: :"4_full"
  defp find_type([c, c | _], :"3_kind"), do: :"4_full"
  defp find_type([c, c, c | rest], :"0_high"), do: find_type(rest, :"3_kind")
  defp find_type([c, c | _], :"1_pair"), do: :"2_pair"
  defp find_type([c, c | rest], :"0_high"), do: find_type(rest, :"1_pair")
  defp find_type([_ | rest], type), do: find_type(rest, type)
  defp find_type([], type), do: type

  defp find_type_2(cards) do
    case Enum.sort(cards) do
      [1 | rest] ->
        Enum.reduce(2..14, :"0_high", fn joker, acc ->
          Kernel.max(acc, find_type_2([joker | rest]))
        end)

      card ->
        find_type(card, :"0_high")
    end
  end

  defp parse_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [cards_str, bet] = line |> String.split(" ", trim: true)

      cards =
        String.graphemes(cards_str)
        |> Enum.map(fn c ->
          case c do
            "T" -> 10
            "J" -> 11
            "Q" -> 12
            "K" -> 13
            "A" -> 14
            _ -> String.to_integer(c)
          end
        end)

      %{cards: cards, bet: String.to_integer(bet)}
    end)
  end
end

AdventOfCode.solve()
