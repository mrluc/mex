defmodule MexTest do
  import Kernel, except: [to_string: 1]

  
  use ExUnit.Case
  doctest Mex

  import IO.ANSI, only: :functions

  test "the truth" do
    assert 1 + 1 == 2
  end

  
  [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white]
  |> Enum.with_index
  |> Enum.map(fn {name, code}->{name, "\e[#{ code + 30 }m" } end)
  |> Enum.each fn
    {atom, code} ->
      def unquote(atom)(str) do
        unquote(code) <> str <> unquote( IO.ANSI.default_color )
      end
    
  end

  def bold(str), do: bright <> str <> normal

  def foo2 do
    """
    :red defmodule :default_color blag do
      not real code dog
    end
    """
  end

  def foo do
    """
    defmodule blag do
      not real code dog
    end

    otherline
    otherone
    """
  end


  def regularize str do
    str
    |> String.split(" ")
    |> Enum.map( &atomize/1 )
    |> IO.ANSI.format(true)
  end

  def atomize( ":" <> rest ), do: String.to_atom( rest )
  def atomize( other ),       do: other <> " "
  
  test "mucking about with colors" do

    #import Mex
    #import Mex.CLI
    
    assert bold( blue("hey") <> " my homie ") <> "how are you?"
    assert regularize foo2

    #side_by_side [foo, foo2, foo ]
    #textmex do
    #  2+2
    #end
  end

  test "rows_to_page works" do

    import Mex.CLI

    rows_to_page [["a","b"],["a","b"]]
    
  end
  
end
