defmodule Awake.Primitives.Functions do
  use Awake.Types
  @moduledoc ~S"""
  Implements primitive functions
  """

  @typep arg_t :: binary() | integer()

  @spec aplus(arg_t(), arg_t()) :: integer()
  def aplus(lhs, rhs), do: _assure_integer(lhs) + _assure_integer(rhs)

  defp _assure_integer(subject)
  defp _assure_integer(subject) when is_integer(subject) do
    subject
  end
  defp _assure_integer(subject) when is_binary(subject) do
    with {result, ""} <- Integer.parse(subject) do
      result
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
