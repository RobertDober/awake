defmodule Awake.Runtime do
  use Awake.Types
  @moduledoc ~S"""
  Runs the compiled pattern against input lines
  """

  @spec run_on_input(Enumerable.t, list(function()), function()) :: :ok
  def run_on_input(stream, compiled, output_fn) do
    initial_state = State.init
    result = stream
    |> Enumerable.reduce(initial_state, fn line, state ->
      new_state = State.update(state, line)
      run(new_state, compiled)
    end)
    if !result.ignore do
      output_fn.(result.output |> Enum.reverse |> Enum.join)
    end
    :ok
  end

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
