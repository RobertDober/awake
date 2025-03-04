defmodule Awake.State do
  use Awake.Types
  @moduledoc ~S"""
  Implements the state of the runtime during execution of the compiled functions
  """

  defstruct line: "",
  lnb: 0,
    fields: [],
    current_ts: nil,
    start_ts: nil,
    opstack: [],
    output: [],
    ignore: false,
    name: nil

  @type t :: %__MODULE__{line: binary(),
    lnb: non_neg_integer(),
    fields: binaries(),
    current_ts: integer(),
    start_ts: integer(),
    opstack: list(),
    output: list(),
    name: binary(),
    ignore: boolean()}




  @type fun_t :: (t() -> t())

  @spec initial() :: t()
  def initial do
    now = System.os_time(:microsecond)
    %__MODULE__{
      current_ts: now,
      start_ts: now,
    }
  end

  @spec new(Keyword.t()) :: t()
  def new(options) do
    line = Keyword.fetch!(options, :line)
    %__MODULE__{
      line:  line,
      fields: String.split(line),
      lnb: Keyword.get(options, :lnb, 0),
      name: Keyword.get(options, :name),
      current_ts: Keyword.get(options, :current_ts, System.os_time(:microsecond)),
      start_ts: Keyword.get(options, :start_ts, System.os_time(:microsecond)),
    }
  end

  @spec update(t(), binary()) :: t()
  def update(%__MODULE__{}=state, line) do
    fields = String.split(line)
    lnb = state.lnb+1
    now = System.os_time(:microsecond)
    %{
      state |
      current_ts: now,
      fields: fields,
      line: line,
      lnb: lnb,
      output: [],
      opstack: [],
    }
  end

  @spec mcs_to_out(t()) :: t()
  def mcs_to_out(%__MODULE__{}=state) do
    get_formatted_time(state, 1, :dec, :out)
  end
  @spec mcs_to_stack(t()) :: t()
  def mcs_to_stack(%__MODULE__{}=state) do
    get_formatted_time(state, 1, :dec, :stack)
  end
  @spec ms_to_out(t()) :: t()
  def ms_to_out(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000, :dec, :out)
  end
  @spec ms_to_stack(t()) :: t()
  def ms_to_stack(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000, :dec, :stack)
  end
  @spec nmcs_to_out(t()) :: t()
  def nmcs_to_out(%__MODULE__{}=state) do
    get_formatted_now(state, 1, :dec, :out)
  end
  @spec nmcs_to_stack(t()) :: t()
  def nmcs_to_stack(%__MODULE__{}=state) do
    get_formatted_now(state, 1, :dec, :stack)
  end
  @spec nms_to_out(t()) :: t()
  def nms_to_out(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000, :dec, :out)
  end
  @spec nms_to_stack(t()) :: t()
  def nms_to_stack(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000, :dec, :stack)
  end
  @spec ns_to_out(t()) :: t()
  def ns_to_out(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000_000, :dec, :out)
  end
  @spec ns_to_stack(t()) :: t()
  def ns_to_stack(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000_000, :dec, :stack)
  end
  @spec nx_to_out(t()) :: t()
  def nx_to_out(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000_000, :hex, :out)
  end
  @spec nx_to_stack(t()) :: t()
  def nx_to_stack(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000_000, :hex, :stack)
  end
  @spec nxm_to_out(t()) :: t()
  def nxm_to_out(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000, :hex, :out)
  end
  @spec nxm_to_stack(t()) :: t()
  def nxm_to_stack(%__MODULE__{}=state) do
    get_formatted_now(state, 1_000, :hex, :stack)
  end
  @spec nxmc_to_out(t()) :: t()
  def nxmc_to_out(%__MODULE__{}=state) do
    get_formatted_now(state, 1, :hex, :out)
  end
  @spec nxmc_to_stack(t()) :: t()
  def nxmc_to_stack(%__MODULE__{}=state) do
    get_formatted_now(state, 1, :hex, :stack)
  end
  @spec s_to_out(t()) :: t()
  def s_to_out(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000_000, :dec, :out)
  end
  @spec s_to_stack(t()) :: t()
  def s_to_stack(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000_000, :dec, :stack)
  end
  @spec x_to_out(t()) :: t()
  def x_to_out(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000_000, :dec, :out)
  end
  @spec x_to_stack(t()) :: t()
  def x_to_stack(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000_000, :dec, :stack)
  end
  @spec xm_to_out(t()) :: t()
  def xm_to_out(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000, :dec, :out)
  end
  @spec xm_to_stack(t()) :: t()
  def xm_to_stack(%__MODULE__{}=state) do
    get_formatted_time(state, 1_000, :dec, :stack)
  end
  @spec xmc_to_out(t()) :: t()
  def xmc_to_out(%__MODULE__{}=state) do
    get_formatted_time(state, 1, :dec, :out)
  end
  @spec xmc_to_stack(t()) :: t()
  def xmc_to_stack(%__MODULE__{}=state) do
    get_formatted_time(state, 1, :dec, :stack)
  end

  @spec lnb_to_out(t()) :: t()
  def lnb_to_out(%__MODULE__{}=state) do
    %{state|output: [state.lnb|state.output]}
  end

  @spec lnb_to_stack(t()) :: t()
  def lnb_to_stack(%__MODULE__{}=state) do
    %{state|opstack: [state.lnb + 1|state.opstack]}
  end

  @spec replace_out(t(), non_neg_integer(), any()) :: t()
  def replace_out(%__MODULE__{}=state, n, push) do
    new_out = [push|state.output]
    %{state|output: new_out, opstack: Enum.drop(state.opstack, n)}
  end

  @spec replace_stack(t(), non_neg_integer(), any()) :: t()
  def replace_stack(%__MODULE__{}=state, n, push) do
    new_stack = [push|Enum.drop(state.opstack, n)]
    %{state|opstack: new_stack}
  end
  @spec to_stack(t(), any()) :: t()
  def to_stack(%__MODULE__{}=state, value) do
    %{state|opstack: [value|state.opstack]}
  end

  @spec to_output(t(), any()) :: t()
  def to_output(%__MODULE__{}=state, value) do
    %{state|output: [value|state.output]}
  end

  @spec get_formatted_time(t(), pos_integer(), time_format(), stack_t()) :: t()
  defp get_formatted_time(%__MODULE__{}=state, divisor, format, target) do
    time = div(state.start_ts, divisor)
    cond do
      target == :stack && format == :dec -> to_stack(state, time)
      target == :stack && format == :hex -> to_stack(state, Integer.to_string(time, 16))
      target == :out && format == :dec -> to_output(state, time)
      target == :out && format == :hex -> to_output(state, Integer.to_string(time, 16))
    end
  end

  @spec get_formatted_now(t(), pos_integer(), time_format(), stack_t()) :: t()
  defp get_formatted_now(%__MODULE__{}=state, divisor, format, target) do
    time = div(state.current_ts, divisor)
    cond do
      target == :stack && format == :dec -> to_stack(state, time)
      target == :stack && format == :hex -> to_stack(state, Integer.to_string(time, 16))
      target == :out && format == :dec -> to_output(state, time)
      target == :out && format == :hex -> to_output(state, Integer.to_string(time, 16))
    end
  end

  # @spec duplicate(t()) :: t()
  # def duplicate(%__MODULE__{opstack: []}=state) do
  #   %{state|opstack: [h, h|t]}
  # end

  # @spec ignore(t()) :: t()
  # def ignore(%__MODULE__{}=state) do
  #   %{state|ignore: true}
  # end

  # @spec pull_args(t(), non_neg_integer()) :: t()
  # def pull_args(%__MODULE__{opstack: stack}=state, missing) do
  #   # TODO: Raise error if stack is too small
  #   args = Enum.take(stack, missing)
  #   {%{state|opstack: Enum.drop(stack, missing)}, args}
  # end

  # @spec push(any(), t()) :: t()
  # def push(value, %__MODULE__{opstack: stack}=state), do: %{state|opstack: [value|stack]}

  # def push_field(%__MODULE__{}=state) do
  #   push(state.line, state)
  # end
  # @spec push_neg_field(t(), neg_integer()) :: t()
  # def push_neg_field(%__MODULE__{fields: fields, opstack: stack}=state, n) do
  #   %{state|opstack: [Enum.at(fields, n)|stack]}
  # end

  # @spec push_pos_field(t(), pos_integer()) :: t()
  # def push_pos_field(%__MODULE__{fields: fields, opstack: stack}=state, n) do
  #   %{state|opstack: [Enum.at(fields, n-1)|stack]}
  # end

  # @spec push_line(t()) :: t()
  # def push_line(%__MODULE__{line: line, opstack: stack}=state) do
  #   %{state|opstack: [line|stack]}
  # end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
