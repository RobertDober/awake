defmodule Awake.Primitives.Functions do
  use Awake.Types
  alias Awake.State
  @moduledoc ~S"""
  Implements primitive functions
  """

  @typep arg_t :: binary() | integer()

  # Special

  def _verb(verbatim) do
    fn _ ->
      verbatim
    end
  end

  # Arithmetic
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

  # String
  @spec lpad(binary(), non_neg_integer(), binary()) :: binary()
  def lpad(subject, size, filler \\ " ") do
    "not yet implemented"
  end

  @spec rpad(binary(), non_neg_integer(), binary()) :: binary()
  def rpad(subject, size, filler \\ " ") do
    "not yet implemented"
  end

  # Internal
  defdelegate duplicate(state), to: Awake.State
  defdelegate ignore(state), to: Awake.State

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
