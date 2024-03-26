defmodule AdventOfCode do
  # concurrent in this case do as well or worse
  # probably because Enum functions already optimized well?
  def solve do
    File.read!("01.txt")
    |> String.split("\n")
    |> Enum.filter(fn line -> String.length(line) > 0 end)
    |> Enum.map(&create_two_digits_number/1)
    # |> Task.async_stream(&create_two_digits_number/1)
    # |> Enum.into([], fn {:ok, res} -> res end)
    |> IO.inspect()
    |> Enum.sum()
    |> IO.inspect()
  end

  defp create_two_digits_number(line) do
    string_number = Regex.replace(~r/\D*/, line, "")
    (String.first(string_number) <> String.last(string_number)) |> String.to_integer()
  end
end

AdventOfCode.solve()
