defmodule Mex.CLI do
  alias IO.ANSI
  
  @width  80
  @joiner ANSI.blue <> "| " <> ANSI.default_color
  @head   [:black, :yellow_background ]

  # public API
  
  def set_width(i), do: Application.put_env( :mex, :width, i )
  def get_width,    do: (Application.get_env( :mex, :width ) || @width)

  def headers heads, sep \\ "->" do
    ANSI.format @head ++ [Enum.map_join(heads, sep, &cell(&1, heads))]
  end
  
  def side_by_side pages do
    pages                                # [A,B]
    |> Enum.map(&String.split(&1, "\n")) # -> [[A1,A2],[B1,B2]]
    |> columns_to_joined_lines           # -> [A1B1, A2B2]
    |> Enum.join("\n")                   # -> A1B1A1B2
  end

  
  # Implementation
  def columns_to_joined_lines cols do
    0..maxlen(cols)-1 |> Enum.map &get_joined_line(&1, cols)
  end

  def get_joined_line i, cols do
    Enum.map_join cols, @joiner, &(Enum.at(&1, i, "") |> cell(cols))
  end

  def cell(text \\ "", cols) do
    w = trunc get_width / Enum.count(cols)
    text |> String.slice(0..w-1) |> String.ljust(w) |> err(text)
  end

  defp maxlen(e), do: Enum.reduce(e, 0, &max(Enum.count(&1), &2))
  defp err(str, "ExpansionError"<>_rest), do: ANSI.red <> str <> ANSI.reset
  defp err(str, _), do: str
  
end
