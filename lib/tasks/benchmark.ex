defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  # By running in separate tasks, garbage collection is separated
  defp run_in_task(fun) do
    fn ->
      fun |> Task.async |> Task.await
    end
  end

  def run(_) do
    Mix.shell.info "Simple Enum mapping 5 elements, four pipes"
    Benchwarmer.benchmark run_in_task fn -> 
      1..5
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
    end

    Mix.shell.info "Simple Stream mapping 5 elements, four pipes"
    Benchwarmer.benchmark run_in_task fn -> 
      1..5
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Enum.to_list
    end

    Mix.shell.info "Simple Enum chain, 1000 items, four pipes"
    Benchwarmer.benchmark run_in_task fn -> 
      1..1000
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
    end

    Mix.shell.info "Simple Stream chain, 1000 items, four pipes"
    Benchwarmer.benchmark run_in_task fn -> 
      1..1000
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Enum.to_list
    end

    Mix.shell.info "Same thing for Enum, with 1 million items"
    Benchwarmer.benchmark run_in_task fn -> 
      1..1_000_000
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
    end

    Mix.shell.info "Same thing for Stream, with 1 million items"
    Benchwarmer.benchmark run_in_task fn -> 
      1..1_000_000
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Enum.to_list
    end

    Mix.shell.info "5 items with Enum that start a task and wait for response"
    Mix.shell.info "(compare looping CPU usage to a simple other task)"
    Benchwarmer.benchmark run_in_task fn -> 
      1..5
      |> Enum.map(fn _ -> 
          (fn -> nil end) |> Task.async |> Task.await
        end)
    end

    Mix.shell.info "5 items with Stream that start a task and wait for response"
    Mix.shell.info "(compare looping CPU usage to a simple other task)"
    Benchwarmer.benchmark run_in_task fn -> 
      1..5
      |> Stream.map(fn _ -> 
          (fn -> nil end) |> Task.async |> Task.await
        end)
      |> Enum.to_list
    end

    Mix.shell.info "Really deep Enum traversal (1000 items, 1000 pipes)"
    Benchwarmer.benchmark run_in_task fn -> 
      Enum.reduce 1..1000, 1..1000, 
        fn _, acc -> 
          Enum.map(acc, fn x -> x * 1.1 end)
        end
    end

    Mix.shell.info "Really deep Stream traversal (1000 items, 1000 pipes)"
    Benchwarmer.benchmark run_in_task fn -> 
      Enum.reduce(1..1000, 1..1000, 
        fn _, acc -> 
          Stream.map(acc, fn x -> x * 1.1 end)
        end)
      |> Enum.to_list
    end
  end
end
