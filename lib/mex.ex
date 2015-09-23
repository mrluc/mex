defmodule Mex do
  import Macro, only: [:to_string]  
  alias Mex.CLI

  # 1. 
  defmacro mex1( do: node ) do
    node
    |> Macro.expand(__CALLER__)
    |> Macro.to_string
    |> IO.puts
  end


  # 2. 
  def expand_all(n, env) do
    Macro.prewalk n, &Macro.expand( &1, env )
  end

  def no_expansion( n, _env), do: n
  
  defmacro mex( do: node ) do
    node
    |> expand_all(__CALLER__)
    |> Macro.to_string
    |> IO.puts
    quote do: :ok
  end


  # 3. command-line fun!
  # see ./mex/cli.ex

  # 4. side-by-side
  @expands [ &Mex.no_expansion/2,
             &Macro.expand_once/2,
             &Macro.expand/2,
             &Mex.expand_all/2 ]
  
  defmacro textmex( do: node ) do
    @expands
    |> Enum.map( fn f -> f.( node, __CALLER__) end)
    |> Enum.map( &Macro.to_string/1 )
    |> CLI.side_by_side
    quote do: :ok
  end
end
