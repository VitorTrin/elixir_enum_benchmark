defmodule Mix.Tasks.Benchmark do
  use Benchfella

  @test_modules [Enum, Stream]
  @sizes [5, 1_000, 1_000_000]

  for module <- @test_modules do
    @module module
    for size <- @sizes do
      @size size

      bench "Four levels of pipes, map with #{@module}, list size #{@size}" do
        1..@size
        |> @module.map(fn _ -> 1.0 end)
        |> @module.map(fn _ -> 1.0 end)
        |> @module.map(fn _ -> 1.0 end)
        |> @module.map(fn _ -> 1.0 end)
        |> Enum.to_list
      end
    end

    bench "Running five Tasks with #{@module} map" do
      1..5
      |> @module.map(fn _ -> (fn -> nil end) |> Task.async |> Task.await end)
      |> Enum.to_list
    end

    bench "1000 length lists, 1000 deep pipes with #{@module}" do
      1..1000
      |> Enum.reduce(1..1000, fn _, acc ->
          acc
          |> @module.map(fn _ -> 1.0 end)
        end)
      |> Enum.to_list
    end
  end

end
