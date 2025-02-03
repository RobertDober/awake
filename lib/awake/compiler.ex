defmodule Awake.Compiler do
  use Awake.Types

  alias Awake.Exceptions.CompilationError
  alias Awake.Builtins
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

  ## Text and Fields

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

      iex(5)> interpret("%t %tm %x %xm", line: "", start_ts: 1738531696911270)
      "1738531696 1738531696911 679fe370 194c890710f"

  If we want to use a timestamp which advances for each input line we need to
  use the same fields as above but with a "c" (for current) prefixed

      iex(6)> interpret("%ct %ctm %cx %cxm", line: "", current_ts: 1738531696911270)
      "1738531696 1738531696911 679fe370 194c890710f"

  As one can see from the stubbing of `start_ts:` and `current_ts:` above, we
  must rely on the runtime to set these correctly in the state

  ## Function Pipelines

  Now let us do some calculations, fianlly!

  If a field is followed by a list of s-expressions, it is parsed to a function pipeline as
  can be seen in the [Parser docs](Awake.Parser.html#parse/1-function-pipelines)

  However, standalone pipelines are not supported yet

      iex(7)> assert_raise Awake.Exceptions.CompilationError,
      ...(7)>     "pure function pipelines (without a preceeding field) are not supported yet!",
      ...(7)>     fn -> interpret("(+ 1 2)", line: "") end

  That now out of the way let us concentrate on pipelines,

  ### String formatting

  When we talk about string formatting we have to keep in mind that, as inspired by _awk_ we are
  treating numbers as strings if dictated by the context, this is the case here

      iex(8)> interpret("%c(lpad 3)", lnb: 73)
      " 73"

      iex(9)> interpret("%c(lpad 4 0)", lnb: 144)
      "0144"


      iex(10)> interpret("%c(rpad 3)", lnb: 73)
      "73 "

      iex(11)> interpret("%c(rpad 4 'x')", lnb: 144)
      "144x"

  ### Artithmetics
  
  Just what you'd expect, again type conversion is done as needed

      iex(12)> interpret("%2(+ 1)", line: "a 42")
      "43"

      iex(13)> interpret("%c(* 2)(- 1)", lnb: 10)
      "19"

  """

  @spec compile(ast_t()) :: binaries()
  def compile(ast) do
    ast
    |> Enum.flat_map(&compile_chunk/1) 
  end

  @spec compile_chunk(ast_entry_t(), Keyword.t) :: list(function()) 
  defp compile_chunk(chunk, options \\ [])
  defp compile_chunk({:verb, text}, _) do
    [&P.string_to_output(&1, text)]
  end
  defp compile_chunk({:field, 0}, options) do
    if Keyword.get(options, :to_opstack) do
      [&P.line_to_opstack/1]
    else
      [&P.line_to_output/1]
    end
  end
  defp compile_chunk({:field, value}, options ) when is_integer(value) and value < 0 do
    if Keyword.get(options, :to_opstack) do
      [&P.field_to_opstack(&1, value)]
    else
      [&P.field_to_output(&1, value)]
    end
  end
  defp compile_chunk({:field, value}, options) when is_integer(value) do
    if Keyword.get(options, :to_opstack) do
      [&P.field_to_opstack(&1, value - 1)]
    else
      [&P.field_to_output(&1, value - 1)]
    end
  end
  defp compile_chunk({:field, name}, options) do
    P.builtin_field(name, options)
  end
  defp compile_chunk({:func, _}, _) do
    raise CompilationError, "pure function pipelines (without a preceeding field) are not supported yet!"
  end
  defp compile_chunk({:pipe, name, s_expressions}, _) do
    header = compile_chunk({:field, name}, to_opstack: true)
    footer = [&P.opstack_to_output/1]
    header ++ compile_pipeline(s_expressions) ++ footer
  end

  @spec compile_pipeline(list()) :: list(function())
  defp compile_pipeline(s_expressions) do
    s_expressions
    |> Enum.flat_map(&compile_s_expression/1) 
  end

  @spec compile_s_expression(list()) :: list(function())
  defp compile_s_expression([id|args]) do
    fun =  Builtins.fetch(id)
    [&P.call_fun_with_opstack(&1, fun, args)]
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
