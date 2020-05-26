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
        |> Enum.to_list()
      end
    end

    bench "Running five Tasks with #{@module} map" do
      1..5
      |> @module.map(fn _ -> fn -> nil end |> Task.async() |> Task.await() end)
      |> Enum.to_list()
    end

    bench "1000 length lists, 1000 deep pipes with #{@module}" do
      1..1000
      |> Enum.reduce(1..1000, fn _, acc ->
        acc
        |> @module.map(fn _ -> 1.0 end)
      end)
      |> Enum.to_list()
    end
  end

  def benchee_run do
    Benchee.run(%{
      "four_levels_of_pipes size 5 Enum" => fn -> four_levels_of_pipes(Enum, 5) end,
      "four_levels_of_pipes size 5 Stream" => fn -> four_levels_of_pipes(Stream, 5) end,
      "five_tasks size 5 Enum" => fn -> five_tasks(Enum) end,
      "five_tasks size 5 Stream" => fn -> five_tasks(Stream) end,
      "1000 length lists 1000 deep pipes Enum" => fn -> very_deep(Enum) end,
      "1000 length lists 1000 deep pipes Stream" => fn -> very_deep(Stream) end,
      "four_levels_of_pipes size 1000000 Enum" => fn -> four_levels_of_pipes(Enum, 1_000_000) end,
      "four_levels_of_pipes size 1000000 Stream" => fn ->
        four_levels_of_pipes(Stream, 1_000_000)
      end
    })
  end

  def benchee_run_2 do
    Benchee.run(%{
      "four_levels_of_pipes_actual_transformations size 1000000 Enum" => fn ->
        four_levels_of_pipes_actual_transformations(Enum, 1_000_000)
      end,
      "four_levels_of_pipes_actual_transformations size 1000000 Stream" => fn ->
        four_levels_of_pipes_actual_transformations(Stream, 1_000_000)
      end
    })
  end

  def benchee_run_3 do
    Benchee.run(
      %{
        "four_levels_of_pipes size 5 Enum" => fn -> four_levels_of_pipes(Enum, 5) end,
        "four_levels_of_pipes size 5 Stream" => fn -> four_levels_of_pipes(Stream, 5) end,
        "five_tasks size 5 Enum" => fn -> five_tasks(Enum) end,
        "five_tasks size 5 Stream" => fn -> five_tasks(Stream) end,
        "1000 length lists 1000 deep pipes Enum" => fn -> very_deep(Enum) end,
        "1000 length lists 1000 deep pipes Stream" => fn -> very_deep(Stream) end,
        "four_levels_of_pipes size 1000000 Enum" => fn ->
          four_levels_of_pipes(Enum, 1_000_000)
        end,
        "four_levels_of_pipes size 1000000 Stream" => fn ->
          four_levels_of_pipes(Stream, 1_000_000)
        end
      },
      memory_time: 2
    )
  end

  defp four_levels_of_pipes(module, size) do
    1..size
    |> module.map(fn _ -> 1.0 end)
    |> module.map(fn _ -> 1.0 end)
    |> module.map(fn _ -> 1.0 end)
    |> module.map(fn _ -> 1.0 end)
    |> Enum.to_list()
  end

  defp five_tasks(module) do
    1..5
    |> module.map(fn _ -> fn -> nil end |> Task.async() |> Task.await() end)
    |> Enum.to_list()
  end

  defp very_deep(module) do
    1..1000
    |> Enum.reduce(1..1000, fn _, acc ->
      acc
      |> @module.map(fn _ -> 1.0 end)
    end)
    |> Enum.to_list()
  end

  defp four_levels_of_pipes_actual_transformations(module, size) do
    1..size
    |> module.map(fn _ -> %{"key" => "tacotruckbanana"} end)
    |> module.map(fn %{"key" => value} -> %{"key" => String.reverse(value)} end)
    |> module.map(fn %{"key" => value} -> %{"key" => String.reverse(value)} end)
    |> module.map(fn %{"key" => value} -> %{"key" => String.reverse(value)} end)
    |> Enum.to_list()
  end
end
