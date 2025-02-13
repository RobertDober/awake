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

  @spec ignore(t()) :: t()
  def ignore(%__MODULE__{}=state), do: %{state|ignore: true}

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

  @spec duplicate(t()) :: t()
  def duplicate(%__MODULE__{opstack: [h|t]}=state) do
    %{state|opstack: [h, h|t]}
  end

  @spec ignore(t()) :: t()
  def ignore(%__MODULE__{}=state) do
    %{state|ignore: true}
  end

  @spec push(t(), any()) :: t()
  def push(%__MODULE__{opstack: stack}=state, value), do: %{state|opstack: [value|stack]}

  @spec push_neg_field(t(), negative_integer()) :: t()
  def push_neg_field(%__MODULE__{fields: fields, opstack: stack}=state, n) do
    %{state|opstack: [Enum.at(fields, n)|stack]}
  end

  @spec push_pos_field(t(), positive_integer()) :: t()
  def push_pos_field(%__MODULE__{fields: fields, opstack: stack}=state, n) do
    %{state|opstack: [Enum.at(fields, n-1)|stack]}
  end

  @spec push_line(t()) :: t()
  def push_line(%__MODULE__{line: line, opstack: stack}=state) do
    %{state|opstack: [line|stack]}
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
