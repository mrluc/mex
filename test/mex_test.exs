
defmodule Prewalk do
  def inspect_leaf_nodes tree do
    tree |> Macro.prewalk &( (is_list(&1) && &1) || to_string(&1))
  end
end

defmodule MexTest do
  import Kernel, except: [to_string: 1]

  
  use ExUnit.Case
  doctest Mex

  import IO.ANSI, only: :functions

  def bold(str), do: bright <> str <> normal

  def regularize str do
    str
    |> String.split(" ")
    |> Enum.map( &atomize/1 )
    |> IO.ANSI.format(true)
  end

  def atomize( ":" <> rest ), do: String.to_atom( rest )
  def atomize( other ),       do: other <> " "
  
  test "mucking about with colors" do
    assert bold( blue <> "hey" <> " my homie ") <> "how are you?"
    assert regularize ":red :bright Red and bold :normal normal"
  end

  test "Mex can set_width of output" do
    assert :ok = Mex.set_width 100

    import Mex
    require Integer
    
    mex 1 do Integer.is_odd(3) end
    
  end

  test "prewalk htmlify" do
    import Prewalk
    str = "name"

    IO.inspect Prewalk.inspect_leaf_nodes [
      [:a], [ [:b], 2, "thing" ], [ :c, [ :d, :e, [:f, :g]], :h]]
  end

end
