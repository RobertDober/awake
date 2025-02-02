defmodule Awake.Compiler do
  use Awake.Types

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

  """

  @doc ~S"""

  These doctests use the parser to generate the ast, so if you want to see
  the AST that is passed into compile, please refer to [doctests of the Parser](awake.Parser.html)
  or look at the [detailed tests](test/compiler)

  A simple task first

      iex(1)> comp("hello %%")
      [ "pshouthello %" ]
  
  """
  @spec compile(ast_t()) :: binaries()
  def compile(ast) do
    ast
    |> Enum.flat_map(&compile_chunk/1) 
  end

  @spec compile_chunk(ast_entry_t()) :: binaries()
  defp compile_chunk(chunk)
  defp compile_chunk({:verb, text}) do
    [ "pshout#{text}" ]
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
