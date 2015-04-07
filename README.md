# Enum vs Stream in Elixir benchmarks

## Results on my machine

    Four levels of pipes, map with Elixir.Enum, list size 5              500000   7.22 µs/op
    Four levels of pipes, map with Elixir.Stream, list size 5            100000   12.10 µs/op
    Running five Tasks with Elixir.Enum map                               50000   38.18 µs/op
    Running five Tasks with Elixir.Stream map                             50000   45.02 µs/op
    Four levels of pipes, map with Elixir.Enum, list size 1000            10000   219.08 µs/op
    Four levels of pipes, map with Elixir.Stream, list size 1000          10000   289.49 µs/op
    1000 length lists, 1000 deep pipes with Elixir.Stream                   100   26146.89 µs/op
    1000 length lists, 1000 deep pipes with Elixir.Enum                      50   41580.70 µs/op
    Four levels of pipes, map with Elixir.Enum, list size 1000000             5   285718.00 µs/op
    Four levels of pipes, map with Elixir.Stream, list size 1000000           5   298559.40 µs/op


