defmodule Awake.Primitives do
  use Awake.Types
  alias Awake.State

  @moduledoc ~S"""
  Implements primitive operations of the runtime
  """

  @type fun_t :: (State.t -> State.t)

  @spec builtin_field(binary(), Keyword.t) :: list(fun_t())
  def builtin_field(name, options) do
    name = if Keyword.get(options, :to_opstack), do: "#{name}_op", else: name
    name = name |> String.to_atom
    [Map.fetch!(builtin_fields(), name)]
  end

  @spec call_fun_with_opstack(State.t, function(), list()) :: State.t
  def call_fun_with_opstack(%State{opstack: opstack}=state, fun, args) do
    actual_args = opstack ++ args
    case fun.(actual_args) do
      result when is_list(result) -> State.update(state, opstack: result)
      result  -> State.update(state, opstack: [result])
    end
  end

  @spec curr_dec_secs_to_opstack(State.t) :: State.t
  def curr_dec_secs_to_opstack(%State{current_ts: current_ts, opstack: opstack}=state) do
    %{state | opstack: [div(current_ts, 1_000_000)|opstack]}
  end

  @spec curr_dec_milli_to_opstack(State.t) :: State.t
  def curr_dec_milli_to_opstack(%State{current_ts: current_ts, opstack: opstack}=state) do
    %{state | opstack: [div(current_ts, 1_000)|opstack]}
  end

  @spec curr_hex_secs_to_opstack(State.t) :: State.t
  def curr_hex_secs_to_opstack(%State{current_ts: current_ts, opstack: opstack}=state) do
    %{state | opstack: [to_hex(current_ts, 1_000_000)|opstack]}
  end

  @spec curr_hex_milli_to_opstack(State.t) :: State.t
  def curr_hex_milli_to_opstack(%State{current_ts: current_ts, opstack: opstack}=state) do
    %{state | opstack: [to_hex(current_ts, 1_000)|opstack]}
  end

  @spec dec_secs_to_opstack(State.t) :: State.t
  def dec_secs_to_opstack(%State{start_ts: start_ts, opstack: opstack}=state) do
    %{state | opstack: [div(start_ts, 1_000_000)|opstack]}
  end

  @spec dec_milli_to_opstack(State.t) :: State.t
  def dec_milli_to_opstack(%State{start_ts: start_ts, opstack: opstack}=state) do
    %{state | opstack: [div(start_ts, 1_000)|opstack]}
  end

  @spec hex_secs_to_opstack(State.t) :: State.t
  def hex_secs_to_opstack(%State{start_ts: start_ts, opstack: opstack}=state) do
    %{state | opstack: [to_hex(start_ts, 1_000_000)|opstack]}
  end

  @spec hex_milli_to_opstack(State.t) :: State.t
  def hex_milli_to_opstack(%State{start_ts: start_ts, opstack: opstack}=state) do
    %{state | opstack: [to_hex(start_ts, 1_000)|opstack]}
  end

  @spec field_to_opstack(State.t, integer()) :: State.t
  def field_to_opstack(%State{fields: fields, opstack: opstack}=state, index) do
    %{state | opstack: [Enum.at(fields, index)|opstack]}
  end

  @spec lnb_to_opstack(State.t) :: State.t
  def lnb_to_opstack(%State{lnb: lnb, opstack: opstack}=state) do
    %{state | opstack: [lnb|opstack]}
  end

  @spec line_to_opstack(State.t) :: State.t
  def line_to_opstack(%State{line: line, opstack: opstack}=state) do
    %{state | opstack: [line|opstack]}
  end

  @spec curr_dec_secs_to_output(State.t) :: State.t
  def curr_dec_secs_to_output(%State{current_ts: current_ts, output: output}=state) do
    %{state | output: [div(current_ts, 1_000_000)|output]}
  end

  @spec curr_dec_milli_to_output(State.t) :: State.t
  def curr_dec_milli_to_output(%State{current_ts: current_ts, output: output}=state) do
    %{state | output: [div(current_ts, 1_000)|output]}
  end

  @spec curr_hex_secs_to_output(State.t) :: State.t
  def curr_hex_secs_to_output(%State{current_ts: current_ts, output: output}=state) do
    %{state | output: [to_hex(current_ts, 1_000_000)|output]}
  end

  @spec curr_hex_milli_to_output(State.t) :: State.t
  def curr_hex_milli_to_output(%State{current_ts: current_ts, output: output}=state) do
    %{state | output: [to_hex(current_ts, 1_000)|output]}
  end

  @spec dec_secs_to_output(State.t) :: State.t
  def dec_secs_to_output(%State{start_ts: start_ts, output: output}=state) do
    %{state | output: [div(start_ts, 1_000_000)|output]}
  end

  @spec dec_milli_to_output(State.t) :: State.t
  def dec_milli_to_output(%State{start_ts: start_ts, output: output}=state) do
    %{state | output: [div(start_ts, 1_000)|output]}
  end

  @spec hex_secs_to_output(State.t) :: State.t
  def hex_secs_to_output(%State{start_ts: start_ts, output: output}=state) do
    %{state | output: [to_hex(start_ts, 1_000_000)|output]}
  end

  @spec hex_milli_to_output(State.t) :: State.t
  def hex_milli_to_output(%State{start_ts: start_ts, output: output}=state) do
    %{state | output: [to_hex(start_ts, 1_000)|output]}
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
 
  @spec opstack_to_output(State.t) :: State.t
  def opstack_to_output(state) do
    State.update(state,
      opstack: [],
      output: state.opstack ++ state.output)
  end

  @spec string_to_output(State.t(), binary()) :: State.t()
  def string_to_output(%State{output: output}=state, str) do
    %{state | output: [str|output]}
  end

  defp builtin_fields do
    %{
      c: &lnb_to_output/1,
      ct: &curr_dec_secs_to_output/1,
      ctm: &curr_dec_milli_to_output/1,
      cx: &curr_hex_secs_to_output/1,
      cxm: &curr_hex_milli_to_output/1,
      t: &dec_secs_to_output/1,
      tm: &dec_milli_to_output/1,
      x: &hex_secs_to_output/1,
      xm: &hex_milli_to_output/1,
      c_op: &lnb_to_opstack/1,
      ct_op: &curr_dec_secs_to_opstack/1,
      ctm_op: &curr_dec_milli_to_opstack/1,
      cx_op: &curr_hex_secs_to_opstack/1,
      cxm_op: &curr_hex_milli_to_opstack/1,
      t_op: &dec_secs_to_opstack/1,
      tm_op: &dec_milli_to_opstack/1,
      x_op: &hex_secs_to_opstack/1,
      xm_op: &hex_milli_to_opstack/1,
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
