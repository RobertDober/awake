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
  defp compile_chunk({:verb, content}), do: [{:verb, content}]
  defp compile_chunk({:field, number}) when is_integer(number) do
    [{:field, number}]
  end
  defp compile_chunk({:field, primitive}) when is_binary(primitive) do
    [
      get_primitive_name(primitive)
    ]
  end
  defp compile_chunk({:field, whatever}) do
    raise CompilationError, "cannot compile field: #{inspect whatever} is not a number or a binary"
  end
  defp compile_chunk({:pipe, number, s_expressions}) when is_integer(number) do
    [
      {:field, number} | compile_s_expressions(s_expressions)
    ]
  end
  defp compile_chunk({:pipe, name, s_expressions}) when is_binary(name) do
    [
      get_primitive_name(name) | compile_s_expressions(s_expressions)
    ]
  end
  defp compile_chunk({:pipe, whatever, _}) do
    raise CompilationError, "cannot compile filed: #{inspect whatever} is not a number or a binary, at beginning of pipeline"
  end
  defp compile_chunk({:func, s_expressions}) do
    compile_s_expressions(s_expressions)
  end


  @spec compile_invocation(Function.t, atom(), list()) :: symbolic_code()
  defp compile_invocation(%Function{defaults: defaults, needs: needs, pulls: pulls}, name, args) do
    provided = Enum.count(args)
    if provided + pulls > needs do
      raise CompilationError, "function #{name} allows only #{needs} args, but #{provided} were given and #{pulls} will be injected at runtime"
    end
    missing = needs - provided - pulls
    args = args ++ Enum.take(defaults, missing)
    new_provided = Enum.count(args)
    missing = needs - new_provided - pulls
    if missing > 0 do
      raise CompilationError, "function #{name} needs #{needs} args, but #{new_provided} were given and only #{pulls} will be injected at runtime"
    end
    arity = max(needs,provided + pulls)
    (args |> Enum.map(&{:push, &1})) ++ [{:invoke, arity, name}]
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

  @spec get_primitive_name(atom()|binary()) :: symbolic_instruction()
  defp get_primitive_name(symbol) do
    name_of_primitive = Primitives.get_field_name(symbol)
    if name_of_primitive do
      {name_of_primitive}
    else
      raise CompilationError, "#{symbol} is not a defined primitive field"
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
