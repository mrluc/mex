

defmodule Mex.CLI.Test do
  use ExUnit.Case
  doctest Mex.CLI
  alias Mex.CLI
  import Mex.CLI

  test "headers() can handle array of strings" do
    assert headers String.duplicate("hey,", 4) |> String.split(",")
    assert headers String.duplicate("asdfasdfasdf,",20 ) |> String.split(",")
  end
  
  test "headers() uses -> as a separator" do
    assert headers(["a", "b"]) |> to_string |> String.contains?("->")
  end

  test "side_by_side() uses | as a separator" do
    assert side_by_side( ["a","b"] ) |> String.contains?("|")
  end

  test "cell() correctly sizes cell text for columns" do
    w = get_width()
    num_cols = 3
    assert trunc(w/num_cols) == String.length cell("txt", [:col, :col, :col])
  end

  # TODO actually, the separators are additional to the defined width.
end
