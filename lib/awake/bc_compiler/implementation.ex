defmodule Awake.BcCompiler.Implementation do
  use Awake.Types
  alias Awake.{Exceptions.CompilationError, Primitives, Primitives.Function}

  @moduledoc false

  @spec compile(ast_t()) :: symbolic_code()
  def compile(chunks) do
    chunks
    |> Enum.flat_map(&compile_chunk/1) 
  end

  @spec compile_chunk(ast_entry_t()) :: symbolic_code()
  defp compile_chunk(chunk)
  defp compile_chunk({:verb, content}), do: [{:strtoout, content}]
  defp compile_chunk({:field, number}) when is_integer(number) do
    [{:fieldout, number}]
  end
  defp compile_chunk({:field, primitive}) when is_binary(primitive) do
    [
      get_primitive_name(primitive, "out")
    ]
  end
  defp compile_chunk({:field, whatever}) do
    raise CompilationError, "cannot compile field: #{inspect whatever} is not a number or a binary"
  end
  defp compile_chunk({:pipe, number, s_expressions}) when is_integer(number) do
    [
      {:fieldstk, number} | compile_s_expressions(s_expressions)
    ]
  end
  defp compile_chunk({:pipe, name, s_expressions}) when is_binary(name) do
    [
      get_primitive_name(name, "stk") | compile_s_expressions(s_expressions)
    ]
  end
  defp compile_chunk({:pipe, whatever, _}) do
    raise CompilationError, "cannot compile filed: #{inspect whatever} is not a number or a binary, at beginning of pipeline"
  end

  @spec compile_invocation(Function.t, atom(), list()) :: symbolic_code()
  defp compile_invocation(%Function{allows: allows, needs: needs, pulls: pulls}, name, args) do
    provided = Enum.count(args)
    if provided + pulls > allows do
      raise CompilationError, "function #{name} allows only #{allows} args, but #{provided} were given and #{pulls} will be injected at runtime"
    end
    arity = max(needs,provided + pulls)
    (args |> Enum.map(&{:pushtostk, &1})) ++ [{:invkstk, arity, name}]

    
  end

  @spec compile_s_expressions(list(list())) :: symbolic_code()
  defp compile_s_expressions(s_expressions) do
    s_expressions
    |> Enum.flat_map(&compile_s_expression/1)
  end

  @spec compile_s_expression(list()) :: symbolic_code()
  defp compile_s_expression(s_expression)
  defp compile_s_expression([name | args]) do
    fun = Primitives.get_function(name)
    if fun do
      compile_invocation(fun, name, args)
    else
      raise CompilationError, "function with name: #{name} not found"
    end
  end

  @spec get_primitive_name(atom()|binary(), binary()) :: symbolic_instruction()
  defp get_primitive_name(symbol, which_stack) do
    name_of_primitive = Primitives.get_field_name(symbol)
    if name_of_primitive do
      {"#{name_of_primitive}to#{which_stack}" |> String.to_atom }
    else
      raise CompilationError, "#{symbol} is not a defined primitive field"
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
