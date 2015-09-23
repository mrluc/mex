defmodule Mex.CLI do

  import IO.ANSI, only: :functions
  
  @width 160
  def side_by_side pages do
    pages
    |> pages_to_columns
    |> columns_to_rows
    |> rows_to_page
    |> IO.puts
  end

  def pages_to_columns(ls) do
    Enum.map ls, fn txt ->
      txt
      |> String.split("\n")
      |> Enum.map( &String.slice( &1, 0..(width(ls)-1) ))
      |> Enum.map( &String.ljust( &1, width(ls) ))
    end
  end
  
  def columns_to_rows cols do
    len = cols |> Enum.reduce 0, &max(Enum.count(&1), &2)
    Enum.map 0..len, fn i ->
      Enum.map(cols, &Enum.at(&1, i, cell(cols)))
    end
  end

  def rows_to_page(rs, t\\yellow, r\\default_color ) do
    Enum.reduce rs, "", &(&2<> Enum.join(&1, "#{t}| #{r}") <>"\n")
  end
      
  def at_index_in(i, cols, default) do
    cols |> Enum.map(cols, &Enum.at(&1, i, default ))
  end

  defp cell(cols),  do: String.ljust "", width(cols)
  defp width(cols), do: trunc @width / Enum.count( cols )
  
end
