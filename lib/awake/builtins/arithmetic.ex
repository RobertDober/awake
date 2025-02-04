defmodule Awake.Builtins.Arithmetic do
  use Awake.Types

  alias Awake.Exceptions.RuntimeError

  @moduledoc false

  @spec _assure_integer(binary() | integer()) :: integer()
  def _assure_integer(subject)
  def _assure_integer(subject) when is_integer(subject) do
    subject
  end
  def _assure_integer(subject) when is_binary(subject) do
    with {number, _} <- Integer.parse(subject), do: number
  end

  @spec adiv(list()) :: integer()
  def adiv(args)
  def adiv([lhs, rhs]) do
    div(_assure_integer(lhs), _assure_integer(rhs))
  end
  def adiv(list) do
    raise RuntimeError, "/ needs exactly 2 arguments, but was given #{inspect(list)}"
  end

  @spec aminus(list()) :: integer()
  def aminus(args)
  def aminus([lhs, rhs]) do
    _assure_integer(lhs) - _assure_integer(rhs)
  end
  def aminus(list) do
    raise RuntimeError, "- needs exactly 2 arguments, but was given #{inspect(list)}"
  end

  @spec amod(list()) :: integer()
  def amod(args)
  def amod([lhs, rhs]) do
    Integer.mod(_assure_integer(lhs), _assure_integer(rhs))
  end
  def amod(list) do
    raise RuntimeError, "% needs exactly 2 arguments, but was given #{inspect(list)}"
  end

  @spec amult(list()) :: integer()
  def amult(args)
  def amult([lhs, rhs]) do
    _assure_integer(lhs) * _assure_integer(rhs)
  end
  def amult(list) do
    raise RuntimeError, "* needs exactly 2 arguments, but was given #{inspect(list)}"
  end

  @spec aplus(list()) :: integer()
  def aplus(args)
  def aplus([lhs, rhs]) do
    _assure_integer(lhs) + _assure_integer(rhs)
  end
  def aplus(list) do
    raise RuntimeError, "+ needs exactly 2 arguments, but was given #{inspect(list)}"
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
