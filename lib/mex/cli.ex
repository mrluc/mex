defmodule Mex.CLI do
  alias IO.ANSI
  
  @width  80
  @joiner ANSI.blue <> "| " <> ANSI.default_color
  @head   [:black, :yellow_background ]
  
  def print_side_by_side pages do
    IO.puts pages
    |> to_columns_of_lines
    |> to_rows_of_lines
    |> to_page
  end

  def print_headers heads do
    IO.puts ANSI.format @head ++ [Enum.map_join(heads, "->", &cell(heads,&1))]
  end

  def set_width(i), do: Application.put_env( :mex, :width, i )

  
  def to_columns_of_lines(pages) do
    pages
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(&to_cells( pages, &1))
  end
  
  def to_rows_of_lines(cols) do
    # turn into rows containing 'line i from each column'
    Enum.map 0..maxlen(cols), fn i ->
      Enum.map cols, &Enum.at(&1, i, cell(cols,""))
    end
  end

  def to_page(rows) do
    Enum.map_join rows, "\n", &(Enum.join(&1, @joiner))
  end

  def to_cells(cols, lines) do
    lines |> Enum.map &cell(cols, &1)
  end
  
  def cell(cols, text \\ "") do
    text
    |> String.slice( 0..(cell_width(cols)-1) ) # truncate lines,
    |> String.ljust( cell_width cols )         # and pad empty space.
  end
  
  defp cell_width(cols) do
    trunc print_width / Enum.count( cols )
  end
  
  defp print_width do
    Application.get_env( :mex, :width ) || @width
  end
  
  defp maxlen(e) do
    Enum.reduce e, 0, &max( Enum.count(&1), &2 )
  end
  
end
