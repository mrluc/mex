defmodule Mex do
  alias Mex.CLI
  defdelegate set_width(num_chars), to: Mex.CLI

  @name [ none: &Mex.no_expansion/2, once: &Macro.expand_once/2,
          expand: &Macro.expand/2, all: &Mex.expand_all/2 ]
  
  @pos [[:none, :once, :expand, :all],
         [:all], [:expand, :all], [:once, :expand, :all]]
             
  def by_name(atom), do: @name[atom]
  def by_column_count(i) do
    Enum.map (Enum.at(@pos,i)||List.first(@pos)), &by_name/1
  end

  @doc """
  Call with a `do..end` block, preceded by an optional parameter:

  - a number 1-3, to limit number of expansions to show side by side
  - a single named expander, one of `:none, :once, :expand, :all`

  If you'd like to compare the output of your own expanders side by side,
  see `Mex.pp_compare`.
  """
  defmacro mex( num \\ 0, rest )
  defmacro mex( num, do: node ) when is_integer(num) do
    pp_compare node, __CALLER__, by_column_count(num)
    quote do: :ok
  end

  defmacro mex( atom, do: node ) when is_atom(atom) do
    pp_compare node, __CALLER__, [by_name(atom)]
    quote do: :ok
  end

  @doc """ 
  Display the expansion of a `node` side-by-side in `env`,
  expanded by `expanders`, a list of anonymous expansion functions.
  """
  def pp_compare node, env, expanders do
    {texts, errors} = try_expansions( node, env, expanders)
    
    IO.puts expanders |> Enum.map(&inspect/1) |> CLI.headers 
    IO.puts texts |> CLI.side_by_side
    IO.puts errors |> Enum.reject(&is_nil/1) |> Enum.map_join("\n", &(" "<>&1))
  end

  def expand_all(n, env) do
    Macro.prewalk n, &Macro.expand( &1, env )
  end
  
  def no_expansion( node, _env), do: node


  # error handling
  def try_expansions( node, env, fns ) do
    fns
    |> Enum.map( &try_expand( &1, node, env ))
    |> Enum.reduce( {[],[]}, &accum_expansion/2 )
  end
  
  defp accum_expansion {_status, txt, err}, {pages, errs} do
    {pages ++ [txt], errs ++ [err]}
  end
  
  defp try_expand f, node, env do
    import IO.ANSI
    try do
      {:ok, (f.(node, env) |> Macro.to_string), nil}
    rescue
      e ->
        { :err, "ExpansionError", "#{bright}#{inspect(f)}#{normal} - #{e.message}" }
    end
  end
  
end

