defmodule Awake.Compiler.CompilerImplementation do
  use Awake.Types

  alias Awake.{Primitives, State}
  alias Awake.Primitives.{Function, Functions}
  alias Awake.Exceptions.CompilationError
  @moduledoc false

  @spec compile(ast_t()) :: function()
  def compile(chunks) do
    chunks
    |> Enum.map(&compile_chunk/1) 
  end

  @spec compile_chunk(ast_entry_t()) :: function()
  defp compile_chunk(chunk)
  defp compile_chunk({:verb, string}) do
    &State.push(string, &1)
  end
  defp compile_chunk({:field, 0}) do
    &State.push_line/1
  end
  defp compile_chunk({:field, number}) when is_number(number) and number > 0 do
    &State.push_pos_field(&1, number)
  end
  defp compile_chunk({:field, number}) when is_number(number) do
    &State.push_neg_field(&1, number)
  end
  defp compile_chunk({:field, name}) do
    case Primitives.get_field_function(name) do
      %Function{fun: fun} -> &(&1.(&2))
      _ -> raise CompilationError, "undefined field #{name}"
    end
  end
  defp compile_chunk({:pipe, field, s_expressions}) do
    # IO.inspect(s_expressions, label: :pipe)
    compiled_field = compile_field(field)
    compiled_functions = s_expressions |> Enum.map(&compile_s_expression/1)
    fn state ->
      [compiled_field | compiled_functions]
      |> Enum.reduce(state, &(&1.(&2))) 
    end
  end
  defp compile_chunk({:func, s_expressions}) do
    # IO.inspect(s_expressions, label: :func)
    compiled_functions = s_expressions
    |> Enum.map(&compile_s_expression/1)
    fn state ->
      compiled_functions  |> Enum.reduce(state, &(&1.(&2))) 
    end
  end

  defp compile_field(field)
  defp compile_field(n) when is_integer(n) and n>0 do
    &State.push_pos_field(&1, n)
  end
  defp compile_field(n) when is_integer(n) and n<0 do
    &State.push_neg_field(&1, n)
  end
  defp compile_field(0) do
    &State.push_line/1
  end

  defp compile_s_expression([name | args]) do
    Primitives.get_function(name)
    |> compile_to_funcall(args)
  end

  @spec compile_to_funcall(Function.t(), list()) :: function()
  defp compile_to_funcall(function, args)
  defp compile_to_funcall(%Function{fun: fun, needs: 0}, args) do
    &(fun.(&1))
  end
  defp compile_to_funcall(%Function{fun: fun, needs: needs, pulls: pulls, defaults: defaults, name: name}, args) do
    args = args ++ defaults
    missing = max(0, needs - Enum.count(args))
    &(fun.(&1, args, missing))
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
