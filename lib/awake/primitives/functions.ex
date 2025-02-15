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

  # Fields

  # current time in milliseconds formatted as decimal
  @spec ctm(State.t) :: State.t
  def ctm(%State{}=state) do
    state.current_ts
    |> Integer.floor_div(1_000)
    |> State.push(state)
  end

  # current time in seconds formatted as decimal
  @spec cts(State.t) :: State.t
  def cts(%State{}=state) do
    state.current_ts
    |> Integer.floor_div(1_000_000)
    |> State.push(state)
  end

  # current time in milliseconds formatted as hexadecimal
  @spec cxm(State.t) :: State.t
  def cxm(%State{}=state) do
    state.current_ts
    |> Integer.floor_div(1_000)
    |> Integer.to_string(16)
    |> String.downcase
    |> State.push(state)
  end

  # current time in seconds formatted as hexadecimal
  @spec cxs(State.t) :: State.t
  def cxs(%State{}=state) do
    state.current_ts
    |> Integer.floor_div(1_000_000)
    |> Integer.to_string(16)
    |> String.downcase
    |> State.push(state)
  end

  # current line number
  @spec lnb(State.t) :: State.t
  def lnb(%State{}=state) do
    State.push(state.lnb, state)
  end

  # compile time in milliseconds formatted as decimal
  @spec stm(State.t) :: State.t
  def stm(%State{}=state) do
    state.start_ts
    |> Integer.floor_div(1_000)
    |> State.push(state)
  end

  # compile time in seconds formatted as decimal
  @spec sts(State.t) :: State.t
  def sts(%State{}=state) do
    state.start_ts
    |> Integer.floor_div(1_000_000)
    |> State.push(state)
  end

  # compile time in milliseconds formatted as hexadecimal
  @spec sxm(State.t) :: State.t
  def sxm(%State{}=state) do
    state.start_ts
    |> Integer.floor_div(1_000)
    |> Integer.to_string(16)
    |> String.downcase
    |> State.push(state)
  end

  # compile time in seconds formatted as hexadecimal
  @spec sxs(State.t) :: State.t
  def sxs(%State{}=state) do
    state.start_ts
    |> Integer.floor_div(1_000_000)
    |> Integer.to_string(16)
    |> String.downcase
    |> State.push(state)
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

  def aplus(state, args, missing) do
    {new_state, pulled} = State.pull_args(state, missing)
    (pulled ++ args)
    |> _assure_integers()
    |> Enum.reduce(0, &(&1 + &2))
    |> State.push(new_state)
  end

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

  defp _assure_integers(args) do
    args
    |> Enum.map(&_assure_integer/1)
  end

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
