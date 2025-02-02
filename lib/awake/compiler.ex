defmodule Awake.Compiler do
  use Awake.Types

  alias Awake.Primitives, as: P

  @moduledoc ~S"""
  Compiling the AST into a sequence of primitive operations.

  One could imagine that the instructions from the AST to _bytecode_ is as follows

  ```elixir
    # from "%c(+ 1)(* 2) hello"
    compile([{:field, "c"}, {:func, [[:+, 1], [:*, 2]]}, {:verb, " hello"}])
  ```

  ```
    ; :field "c" and pipeline
    lnb2op
    pushop 1
    app2op add*  ; pop whole opstack, apply in reverse order push result to opstack
    pushop 2
    app2out mul*  ; as above but push to output
    ; verb " hello"
    push2out " hello"
  ```

  However in reality these bytecodes are primitives that are implemented as Elixir functions.

  They will then simply be reduced with a state accumulator for each input line

  """

  @doc ~S"""

  These doctests use the parser to generate the ast, so if you want to see
  the AST that is passed into compile, please refer to [doctests of the Parser](awake.Parser.html)
  or look at the [detailed tests](test/compiler)

  We also use a stubbed runtime, (`exec`)  which injects a state into the compiled functions so that we can see the
  result

  A pattern with only :verb chunks (not very useful but it still needs to work), is compiled to this

      iex(1)> functions = comp("hello %%")
      ...(1)> output(functions, line: "immaterial")
      "hello %"

  An echo server, just in case you displaced `cat` (as we are lazy we have yet another helper, which compiles and outputs)

      iex(2)> interpret("%", line: "halloooo")
      "halloooo"

  Lets split lines (or hairs)

      iex(3)> interpret("%1()%-1", line: "a b c")
      "ac"

  Line numbers start at 0, but here we just stub it

      iex(4)> interpret("%c: %", line: "43rd", lnb: 42)
      "42: 43rd"

  Now we have some interesting fields concerning timestamps

  A timestamp is set in microseconds at the start of the compilation
  all fields referring to this timestamp will be identical for all
  input lines

  Right now we support seconds and milliseconds in dec and hex format

      iex(5)> interpret("%t %tm %x %xm", line: "", now: 1738531696911270)
      "1738531696 1738531696911 679fe370 194c890710f"

  """
  @spec compile(ast_t()) :: binaries()
  def compile(ast) do
    ast
    |> Enum.flat_map(&compile_chunk/1) 
  end

  @spec compile_chunk(ast_entry_t()) :: list(function()) 
  defp compile_chunk(chunk)
  defp compile_chunk({:verb, text}) do
    [&P.string_to_output(&1, text)]
  end
  defp compile_chunk({:field, 0}) do
    [&P.line_to_output/1]
  end
  defp compile_chunk({:field, value}) when is_integer(value) and value < 0 do
    [&P.field_to_output(&1, value)]
  end
  defp compile_chunk({:field, value}) when is_integer(value) do
    [&P.field_to_output(&1, value - 1)]
  end
  defp compile_chunk({:field, name}) do
    P.builtin_field(name)
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
