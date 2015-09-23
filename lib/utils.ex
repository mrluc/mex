defmodule Utils do

  def foo do
    """
      :red defmodule :default_color blag do
        not real code dog
      end
    """
  end
  
  def ifs do
    quote do
      if 2 do
        if 3 do
          "trues"
        else
          "falses"
        end
      end
    end
  end
  
  def mod do
    (quote do
      def foo do
        if 2==1 do
          "no way"
        else
          "yes way"
        end
      end
    end) |> wrap_in_module
  end


  defmacro modmex( do: block ) do

    IO.puts "--BINDING-- in the defmacro"
    IO.inspect binding
    
    IO.puts "Original block:"
    IO.inspect block
    
    block = block
    |> wrap_in_module
    |> Macro.expand( __CALLER__ )

    IO.puts "Modulated block:"
    IO.inspect block

    block = block |> strip_module( __CALLER__ )
    
    IO.puts "And with module stripped, block and to_string:"
    IO.inspect block
    IO.puts Macro.to_string block
    IO.puts "And now the unquote block |> Macro.escaped"
    quote do
      unquote block |> Macro.escape
    end
  end

  def wrap_in_module block do
    quote do
      defmodule TempForMex do
        unquote block
      end
    end
  end

  defp strip_module({:__block__, _, [_alias, {_compile, _m, quoted} ]}, env) do
    quoted |> unescaped_module_contents(env)
  end
  defp unescaped_module_contents([ _, lines, _context, _env], _caller_env) do
    lines |> Code.eval_quoted #( bindings )
  end

  
end
