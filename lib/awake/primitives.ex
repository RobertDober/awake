defmodule Awake.Primitives do
  use Awake.Types
  alias Awake.State

  @moduledoc ~S"""
  Implements primitive operations of the runtime
  """

  @type fun_t :: (State.t -> State.t)

  @spec builtin_field(binary()) :: list(fun_t())
  def builtin_field(name) do
    name = name |> String.to_atom
    [Map.fetch!(builtin_fields(), name)]
  end

  @spec dec_secs_to_output(State.t) :: State.t
  def dec_secs_to_output(%State{now: now, output: output}=state) do
    %{state | output: [div(now, 1_000_000)|output]}
  end

  @spec dec_milli_to_output(State.t) :: State.t
  def dec_milli_to_output(%State{now: now, output: output}=state) do
    %{state | output: [div(now, 1_000)|output]}
  end

  @spec hex_secs_to_output(State.t) :: State.t
  def hex_secs_to_output(%State{now: now, output: output}=state) do
    %{state | output: [to_hex(now, 1_000_000)|output]}
  end

  @spec hex_milli_to_output(State.t) :: State.t
  def hex_milli_to_output(%State{now: now, output: output}=state) do
    %{state | output: [to_hex(now, 1_000)|output]}
  end

  @spec field_to_output(State.t, integer()) :: State.t
  def field_to_output(%State{fields: fields, output: output}=state, index) do
    %{state | output: [Enum.at(fields, index)|output]}
  end

  @spec lnb_to_output(State.t) :: State.t
  def lnb_to_output(%State{lnb: lnb, output: output}=state) do
    %{state | output: [lnb|output]}
  end

  @spec line_to_output(State.t) :: State.t
  def line_to_output(%State{line: line, output: output}=state) do
    %{state | output: [line|output]}
  end

  @spec string_to_output(State.t(), binary()) :: State.t()
  def string_to_output(%State{output: output}=state, str) do
    %{state | output: [str|output]}
  end

  defp builtin_fields do
    %{
      c: &lnb_to_output/1,
      t: &dec_secs_to_output/1,
      tm: &dec_milli_to_output/1,
      x: &hex_secs_to_output/1,
      xm: &hex_milli_to_output/1,
    }
  end

  @spec to_hex(integer(), integer()) :: binary()
  defp to_hex(time, factor) do
    time
    |> div(factor) 
    |> Integer.to_string(16) 
    |> String.downcase 
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
