defmodule AdventOfCode do
  # concurrent in this case do as well or worse
  # probably because Enum functions already optimized well?
  # |> Task.async_stream(&create_two_digits_number/1)
  # |> Enum.into([], fn {:ok, res} -> res end)
  def solve do
    File.read!("01.txt")
    |> String.split("\n")
    |> Enum.filter(fn line -> String.length(line) > 0 end)
    |> Enum.map(&get_digits/1)
    |> IO.inspect()
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_digits(line) do
    get_first_digit(line) <> get_last_digit(line)
    |> String.to_integer()
  end

  defp get_first_digit(line) do
    ~r/\d|one|two|three|four|five|six|seven|eight|nine/
    |> Regex.run(line, capture: :first)
    |> List.first()
    |> convert_string_digit()
  end

  defp get_last_digit(line) do
    ~r/\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/
    |> Regex.run(String.reverse(line), capture: :first)
    |> List.first()
    |> String.reverse()
    |> convert_string_digit()
  end

  @lookup %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }
  defp convert_string_digit(digit) do
    if digit in Map.keys(@lookup), do: @lookup[digit], else: digit
  end
end

AdventOfCode.solve()
