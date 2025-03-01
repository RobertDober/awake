defmodule Awake.Function do
  use Awake.Types
  alias Awake.State
  @moduledoc ~S"""
  Module implementing all functions that implement the Virtual Machine Operations
  """

  # TODO: Specify function() with possible argument types
  @type t :: function()

  @spec outputfld(State.t, non_neg_integer()) :: t()
  def outputfld(%State{}=state, fld) do
    State.to_output(state, Enum.at(state.fields, fld))
  end
  @spec outputline(State.t) :: t()
  def outputline(%State{}=state) do
    State.to_output(state, state.line)
  end
  def push(%State{}=state, value) do
    State.to_stack(state, value)
  end
  def outputspc(%State{}=state) do
  end
  def invoke(%State{}=state) do
  end
  def pushspc(%State{}=state) do
  end
  def outputstr(%State{}=state) do
  end


end
# SPDX-License-Identifier: AGPL-3.0-or-later
