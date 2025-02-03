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
    output: []

  @type t :: %__MODULE__{line: binary(),
    lnb: non_neg_integer(),
    fields: binaries(),
    current_ts: integer(),
    start_ts: integer(),
    opstack: list(),
    output: list()}

  @spec new(Keyword.t()) :: t()
  def new(options) do
    line = Keyword.fetch!(options, :line)
    %__MODULE__{
      line:  line,
      fields: String.split(line),
      lnb: Keyword.get(options, :lnb, 0),
      current_ts: Keyword.get(options, :current_ts, System.os_time(:microsecond)),
      start_ts: Keyword.get(options, :start_ts, System.os_time(:microsecond)),
    }
  end

  @spec update(t(), Keyword.t()) :: t()
  def update(%__MODULE__{}=myself, options) do
    new_line = Keyword.get(options, :line)
    line = if new_line, do: new_line, else: myself.line
    fields = if new_line, do: String.split(new_line), else: myself.fields
    %{
      myself |
      line: line,
      lnb: Keyword.get(options, :lnb, myself.lnb),
      fields: fields,
      current_ts: Keyword.get(options, :current_ts, myself.current_ts),
      start_ts: Keyword.get(options, :start_ts, myself.start_ts),
      opstack: replace_or_push(myself.opstack, Keyword.get(options, :opstack, myself.opstack)),
      output: replace_or_push(myself.output, Keyword.get(options, :output, myself.output)),
    }
  end

  @spec replace_or_push(list(), any()) :: list()
  defp replace_or_push(list, list_or_scalar)
  defp replace_or_push(_, list) when is_list(list) do
    list
  end
  defp replace_or_push(list, val), do: [val | list]
end
# SPDX-License-Identifier: AGPL-3.0-or-later
