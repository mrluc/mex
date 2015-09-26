defmodule Mex do

  alias Mex.CLI
  
  defdelegate set_width(num_chars), to: Mex.CLI

  @layouts [
    [&Mex.no_expansion/2, &Macro.expand_once/2, &Macro.expand/2, &Mex.expand_all/2],
    [&Mex.expand_all/2],
    [&Macro.expand/2, &Mex.expand_all/2],
    [&Macro.expand_once/2, &Macro.expand/2, &Mex.expand_all/2]
  ]
  
  defmacro mex( num \\ 0, do: node ) do
    pp_compare node, __CALLER__, (Enum.at( @layouts, num) || List.first(@layouts))
    quote do: :ok
  end
  
  def pp_compare node, env, expanders do
    head = expanders
    |> Enum.map( &inspect/1 )
    |> CLI.headers
    
    body = expanders
    |> Enum.map( &apply( &1, [node,env] ))    # or fn f -> f.( node, env ) end
    |> Enum.map( &Macro.to_string/1 )
    |> CLI.side_by_side

    IO.puts [head, "\n", body]
  end

  def expand_all(n, env) do
    Macro.prewalk n, &Macro.expand( &1, env )
  end
  
  def no_expansion( node, _env), do: node
  
end

