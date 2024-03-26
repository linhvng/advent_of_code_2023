defmodule AdventOfCode do
  def solve do
    almanac = parse("05.txt")

    IO.puts("part 1 answer is #{part_1(almanac)}")
    IO.puts("part 2 answer is #{part_2(almanac)}")
  end

  defp part_1(almanac) do
    almanac.seeds |> find_location(almanac) |> Enum.min()
  end

  defp part_2(almanac) do
    almanac.seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [s, l] -> s..(s + l - 1) end)
    |> find_location(almanac)
    |> Enum.map(fn r -> r.first end)
    |> Enum.min()
  end

  defp find_location(seeds, almanac) do
    steps = [
      :seed_to_soil,
      :soil_to_fert,
      :fert_to_water,
      :water_to_light,
      :light_to_temp,
      :temp_to_humid,
      :humid_to_loc
    ]

    steps
    |> Enum.reduce(seeds, fn step, acc ->
      acc
      |> Enum.map(fn s -> transform(s, Map.get(almanac, step)) end)
      |> List.flatten()
    end)
  end

  defp transform(seed_range, [head | tail]) when not is_integer(seed_range) do
    offset = head.dest.first - head.src.first

    cond do
      # src1----------src2
      #    s1-------s2
      seed_range.first in head.src and seed_range.last in head.src ->
        Range.shift(seed_range, offset)

      #    src1-------src2
      # s1---------s2
      seed_range.first not in head.src and seed_range.last in head.src ->
        [
          seed_range.first..(head.src.first - 1) |> transform(tail),
          head.src.first..seed_range.last |> Range.shift(offset)
        ]

      # src1------src2
      #       s1---------s2
      seed_range.first in head.src and seed_range.last not in head.src ->
        [
          seed_range.first..head.src.last |> Range.shift(offset),
          (head.src.last + 1)..seed_range.last |> transform(tail)
        ]

      #     src1----src2
      # s1-----------------s2
      head.src.first in seed_range and head.src.last in seed_range ->
        [
          seed_range.first..(head.src.first - 1) |> transform(tail),
          head.dest,
          (head.src.last + 1)..seed_range.last |> transform(tail)
        ]

      true ->
        transform(seed_range, tail)
    end
  end

  defp transform(input, []), do: input

  defp transform(input, [head | tail]) when is_integer(input) do
    new_input =
      case input in head.src do
        true -> input + (head.dest.first - head.src.first)
        false -> input
      end

    case new_input === input do
      true -> transform(new_input, tail)
      false -> new_input
    end
  end

  defp parse(file) do
    list_of_maps =
      File.read!(file)
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn line -> String.split(line, "\n", trim: true) end)

    [seeds] =
      list_of_maps
      |> Enum.filter(fn m -> Enum.count(m) == 1 end)
      |> Enum.map(fn s ->
        s
        |> List.first()
        |> String.split("\s", trim: true)
        |> Enum.reject(fn s -> s === "seeds:" end)
        |> Enum.map(&String.to_integer/1)
      end)

    [
      seed_to_soil,
      soil_to_fert,
      fert_to_water,
      water_to_light,
      light_to_temp,
      temp_to_humid,
      humid_to_loc
    ] =
      list_of_maps
      |> Enum.filter(fn m -> Enum.count(m) != 1 end)
      |> Enum.map(fn m ->
        [_name_of_map | map] = m

        map
        |> Enum.map(fn s ->
          [dest, src, length] =
            s
            |> String.split("\s", trim: true)
            |> Enum.map(&String.to_integer/1)

          %{src: src..(src + length - 1), dest: dest..(dest + length - 1)}
        end)
      end)

    %{
      seeds: seeds,
      seed_to_soil: seed_to_soil,
      soil_to_fert: soil_to_fert,
      fert_to_water: fert_to_water,
      water_to_light: water_to_light,
      light_to_temp: light_to_temp,
      temp_to_humid: temp_to_humid,
      humid_to_loc: humid_to_loc
    }
  end
end

AdventOfCode.solve()
