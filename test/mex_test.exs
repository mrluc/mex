defmodule Prewalk do
  def map_leaf_nodes tree, f do
    tree |> Macro.prewalk &( (is_list(&1) && &1) || f.(&1))
  end
end

defmodule MexTest do
  use ExUnit.Case
  doctest Mex
  import Mex
  
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
    require Integer
    result = mex 4 do Integer.is_odd(3) end
    assert :ok = result
  end

  test "our Macro.prewalk example works" do
    assert Prewalk.map_leaf_nodes [[:a], [[:b],2,"thing"]], &Kernel.to_string(&1)
  end

  test "expand_all expands recursively, tested with nested if expressions" do
    assert false ==
      quoted_nested_ifs
      |> Mex.expand_all(__ENV__)
      |> inspect                  # `if` would be :if
      |> String.contains?("if")   #  which works
  end

  test "mex handles expander failure" do
    q = quote do
      def foo, do: 1
    end
    assert {_pages, _errs} =
      Mex.try_expansions q, __ENV__, [Mex.by_name(:all)]

  end

  test "mex understands named expanders" do
    assert {_pages, _errs} =
      Mex.try_expansions quoted_nested_ifs, __ENV__, [Mex.by_name(:all)]
  end

end
