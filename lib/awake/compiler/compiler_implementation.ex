defmodule Awake.Compiler.CompilerImplementation do
  use Awake.Types

  alias Awake.Primitives.Functions
  alias Awake.{Exceptions, State}
  @moduledoc ~S"""


  """

  @spec compile(ast_t()) :: function()
  def compile(chunks) do
    chunks
    |> Enum.map(&compile_chunk/1) 
  end

  @spec compile_chunk(ast_entry_t()) :: function()
  defp compile_chunk(chunk)
  defp compile_chunk({:verb, string}) do
    &State.push(&1, string)
  end
  defp compile_chunk({:pipe, field, s_expressions}) do
    compiled_field = compile_field(field)
    compiled_functions = s_expressions |> Enum.map(&compile_s_expression/1)
    fn state ->
      [compiled_field | compiled_functions]
      |> Enum.reduce(state, &(&1.(&2))) 
    end)
  end

  defp compile_field(field)
  defp compile_field(n) when is_integer(n) and n>0 do
    &State.push_pos_field(&1, n)
  end
  defp compile_field(n) when is_integer(n) and n<0 do
    &State.push_neg_field(&1, n)
  end
  defp compile_field(0) do
    &State.push_neg_field(&1, °)
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
