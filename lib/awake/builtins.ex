defmodule Awake.Builtins do
  alias Awake.Exceptions.CompilationError
  alias Awake.State

  @moduledoc ~S"""
  Implement builtin functions
  """

  @spec fetch(atom()) :: function()
  def fetch(id) do
    case Map.fetch(builtin_functions(), id) do
      {:ok, fun} -> fun
      _ -> raise CompilationError, "the function :#{id} is not defined"
    end
  end

  @spec _assure_integer(binary() | integer()) :: integer()
  defp _assure_integer(subject)
  defp _assure_integer(subject) when is_integer(subject) do
    subject
  end
  defp _assure_integer(subject) when is_binary(subject) do
    with {number, _} <- Integer.parse(subject), do: number
  end

  @spec amult(list()) :: binary()
  defp amult(list)
  defp amult([subject | args]) do
    _amult([_assure_integer(subject)|args])
  end

  @spec _amult(list()) :: integer()
  defp _amult(args) do
    args
    |> Enum.reduce(1, &(&1 * &2)) 
  end

  @spec aplus(list()) :: binary()
  defp aplus(list)
  defp aplus([subject | args]) do
    _aplus([_assure_integer(subject)|args])
  end

  @spec _aplus(list()) :: integer()
  defp _aplus(args) do
    args
    |> Enum.reduce(0, &(&1 + &2)) 
  end

  @spec lpad(list()) :: binary()
  defp lpad([subject, size|args]) do
    apply(String, :pad_leading, [to_string(subject), size | Enum.map(args, &to_string/1)])
  end

  @spec rpad(list()) :: binary()
  defp rpad([subject, size|args]) do
    apply(String, :pad_trailing, [to_string(subject), size | Enum.map(args, &to_string/1)])
  end

  @spec builtin_functions() :: map()
  defp builtin_functions do
    %{
      +:  &aplus/1,
      *:  &amult/1,
      lpad: &lpad/1,
      rpad: &rpad/1,
    }
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
