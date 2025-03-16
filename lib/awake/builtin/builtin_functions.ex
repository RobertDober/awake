defmodule Awake.Builtin.BuiltinFunctions do
  alias Awake.State

  @moduledoc ~S"""
  Implements all functions `f` which are invoked with the syntax `(f ...)` 
  """

  @doc false
  def _add(%State{opstack: opstack} = state) do
    [lhs, rhs | stack] = opstack
    result = _assure_int(lhs) + _assure_int(rhs)
    %{state | opstack: [result | stack]}
  end

  defp _assure_int(value)

  defp _assure_int(value) when is_binary(value) do
    String.to_integer(value)
  end

  defp _assure_int(value) when is_integer(value) do
    value
  end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
