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

  @spec compile(ast_t()) :: binaries()
  def compile(ast) do
    ast
    |> combine_chunks() 
    |> Enum.flat_map(&compile_chunk/1) 
  end

  @spec combine_chunks(ast_t(), ast_t()) :: augmented_t()
  defp combine_chunks(ast, result \\ [])
  defp combine_chunks([], result), do: Enum.reverse(result)
  defp combine_chunks([{:field, field}, {:func, args} | rest], result) do
    combine_chunks(rest, [{:pipe, field, args}|result])
  end
  defp combine_chunks([h|t], result), do: combine_chunks(t, [h|result])

  @spec compile_chunk(ast_entry_t()) :: binaries()
  defp compile_chunk(chunk)
  defp compile_chunk({:verb, text}) do
    [ "push2out#{text}" ]
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
