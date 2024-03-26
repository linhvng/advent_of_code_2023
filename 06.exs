defmodule AdventOfCode do
  def solve do
    parse_input("06.txt")
    |> part_2()
    |> IO.inspect(charlists: :as_list)
  end

  defp part_1(input) do
    input
    |> Enum.map(&count_win_options/1)
    |> Enum.product()
  end

  defp part_2(input) do
    {time, distance} =
      input
      |> Enum.reduce({"", ""}, fn pair, acc ->
        t = Kernel.elem(acc, 0) <> (Kernel.elem(pair, 0) |> Integer.to_string())
        d = Kernel.elem(acc, 1) <> (Kernel.elem(pair, 1) |> Integer.to_string())

        {t, d}
      end)

    {String.to_integer(time), String.to_integer(distance)}
    |> count_win_options()
  end

  defp count_win_options({time, distance}) do
    # this is slow...
    # for winding_time <- 1 .. time - 1 do
    #   speed = winding_time
    #   travel_time = time - winding_time
    #   _travel_distance = speed * travel_time
    # end
    # |> Enum.filter(fn d -> d > distance end)
    # |> Enum.count()

    # much faster but can be even faster if using quadratic equation
    # 1..(time - 1)
    # |> Enum.reduce(0, fn winding_time, ways_to_win ->
    #   case winding_time * (time - winding_time) > distance do
    #     true -> ways_to_win + 1
    #     false -> ways_to_win
    #   end
    # end)

    # quadratic equation
    # winding_time * (time - winding_time) = distance
    # winding_time * time - winding_time ** 2 = distance
    # winding_time ** 2 - winding_time * time + distance = 0
    # a = 1, b = -1 * time, c = distance
    # x = (-b +- sqrt(b*b - 4ac)) / 2
    # winding_time = time +- sqrt(time*time - 4distance)
    delta = :math.sqrt(time * time - 4 * distance)
    v1 = ceil((time - delta) / 2)
    v2 = floor((time + delta) / 2)
    v2 - v1 + 1
  end

  defp parse_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end
end

AdventOfCode.solve()
