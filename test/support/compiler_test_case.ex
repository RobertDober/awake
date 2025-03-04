defmodule Support.CompilerTestCase do
  @moduledoc ~S"""

  """
  defmodule CompilerTestMacros do
    defmacro check_compilation(pattern, symbolic) do
      quote do
        test "#{unquote pattern} to #{inspect(unquote symbolic)}" do
        result = compile(unquote(pattern), true)
        assert unquote(symbolic) == result 
      end
      end
    end


    defmacro describe_result(pattern, input, do: block) do
      name = "describe result #{pattern} -> #{input}"
      quote do
        test unquote(name) do
        compiled = compile(unquote(pattern), false) #  |> IO.inspect() 
        var!(result) = run_compiled(compiled, unquote(input), 1)
        unquote(block)
      end
      end
    end
    defmacro describe_result(pattern, input, lnb, do: block) do
      name = "describe result #{pattern} -> #{input} @ #{lnb}"
      quote do
        test unquote(name) do
        compiled = compile(unquote(pattern), false) #  |> IO.inspect() 
        var!(result) = run_compiled(compiled, unquote(input), unquote(lnb))
        unquote(block)
      end
      end
    end
  end

  defmacro __using__(_opts \\ []) do
    quote do
      use ExUnit.Case
      import CompilerTestMacros
      import Awake.Compiler
      alias Awake.{Runtime, State}

      def comp(pattern) do
      {
        compile(pattern, true),
        compile(pattern, false),
      }
    end

      def run_compiled(functions, line, lnb \\ 1) do
        state = State.new(line: line, start_ts: 1740856140563029) # corresponds roughly to UTC 20250301T190900.562816
        Runtime.run(state, functions)
      end
      def run(compiled, line, lnb \\ 1) do
        run_compiled(compiled[:code], line, lnb)
      end

    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
