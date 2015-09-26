defmodule Prewalk do
  def map_leaf_nodes tree, f do
    tree |> Macro.prewalk &( (is_list(&1) && &1) || f.(&1))
  end
end

defmodule MexTest do
  use ExUnit.Case
  doctest Mex
  
  def quoted_nested_ifs do
    quote do
       if 2 do
         if 3, do: "mouth-watering, honey-glazed ham"
       end
    end
  end
  
  test "Mex can set_width of output" do
    assert :ok = Mex.set_width 100
  end

  test "mex can be given an integer argument" do
    import Mex
    require Integer
    result = mex 4 do Integer.is_odd(3) end
    assert :ok = result
  end

  test "our Macro.prewalk example works" do
    assert Prewalk.map_leaf_nodes [[:a], [[:b],2,"thing"]], &Kernel.to_string(&1)
  end

  test "expand_all expands away nested ifs" do
    assert false ==
      quoted_nested_ifs
      |> Mex.expand_all(__ENV__)
      |> inspect                  # `if` would be :if
      |> String.contains?("if")   #  which works
  end

end
