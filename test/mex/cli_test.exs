

defmodule Mex.CLI.Test do
  use ExUnit.Case
  doctest Mex.CLI
  alias Mex.CLI

  import Mex.CLI
  
  test "to_page combines cells with ansi separators" do
    assert "a\e[34m| \e[39mb\n"<>_rest = CLI.to_page( [["a","b"], ["a","b"]] )
  end

end
