defmodule Awake.Primitives.Functions do
  use Awake.Types
  @moduledoc ~S"""
  Implements primitive functions
  """

  @typep arg_t :: binary() | integer()

  @spec adiv(arg_t(), arg_t()) :: integer()
  def adiv(lhs, rhs), do: _assure_integer(lhs) + _assure_integer(rhs)

  @spec aminus(arg_t(), arg_t()) :: integer()
  def aminus(lhs, rhs), do: _assure_integer(lhs) + _assure_integer(rhs)

  @spec amod(arg_t(), arg_t()) :: integer()
  def amod(lhs, rhs), do: _assure_integer(lhs) + _assure_integer(rhs)

  @spec amult(arg_t(), arg_t()) :: integer()
  def amult(lhs, rhs), do: _assure_integer(lhs) + _assure_integer(rhs)

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
