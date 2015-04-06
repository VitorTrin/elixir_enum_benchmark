defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  def run(_) do
    Mix.shell.info "Simple Enum chain, 1000 items, 4x map"
    Benchwarmer.benchmark fn -> 
      1..1000
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
    end

    Mix.shell.info "Simple Stream chain, 1000 items, 4x map"
    Benchwarmer.benchmark fn -> 
      1..1000
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Enum.to_list
    end

    Mix.shell.info "Same thing for Enum, with 1 million items"
    Benchwarmer.benchmark fn -> 
      1..1_000_000
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
    end

    Mix.shell.info "Same thing for Stream, with 1 million items"
    Benchwarmer.benchmark fn -> 
      1..1_000_000
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Enum.to_list
    end

    Mix.shell.info "Same thing for Enum, with 5 items"
    Benchwarmer.benchmark fn -> 
      1..5
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
      |> Enum.map(fn x -> x * x end)
    end

    Mix.shell.info "Same thing for Stream, with 5 items"
    Benchwarmer.benchmark fn -> 
      1..5
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Stream.map(fn x -> x * x end)
      |> Enum.to_list
    end

    Mix.shell.info "10.000 items with Enum that start a task and wait for response"
    Mix.shell.info "(compare looping CPU usage to a simple other task)"
    Benchwarmer.benchmark fn -> 
      1..10000
      |> Enum.map(fn _ -> 
          me = self
          spawn_link fn -> send me, :pingpong end
          receive do
            :pingpong -> nil
          end
        end)
    end

    Mix.shell.info "10.000 items with Stream that start a task and wait for response"
    Mix.shell.info "(compare looping CPU usage to a simple other task)"
    Benchwarmer.benchmark fn -> 
      1..10000
      |> Enum.map(fn _ -> 
          me = self
          spawn_link fn -> send me, :pingpong end
          receive do
            :pingpong -> nil
          end
        end)
    end

    Mix.shell.info "Really deep Enum traversal (1000 items, 1000 pipes)"
    Benchwarmer.benchmark fn -> 
      Enum.reduce 1..1000, 1..1000, 
        fn _, acc -> 
          Enum.map(acc, fn x -> x * 1.1 end)
        end
    end

    Mix.shell.info "Really deep Stream traversal (1000 items, 1000 pipes)"
    Benchwarmer.benchmark fn -> 
      Enum.reduce(1..1000, 1..1000, 
        fn _, acc -> 
          Stream.map(acc, fn x -> x * 1.1 end)
        end)
      |> Enum.to_list
    end
  end
end
