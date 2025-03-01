defmodule Awake.Runtime do
  use Awake.Types
  @moduledoc ~S"""
  Runs the compiled pattern against input lines
  """

  @spec run(Awake.State.t, list(function())) :: Awake.State.t
  def run(state, compiled) do
    compiled
    |> Enum.reduce_while(state, fn fun, st -> 
      new_state = fun.(st)
      if new_state.ignore do
        {:halt, new_state}
      else
        {:cont, new_state}
      end
    end)
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
