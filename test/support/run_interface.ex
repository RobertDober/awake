defmodule Support.RunInterface do
  @moduledoc ~S"""
  Easy creatio of Options for specific test
  """

  alias Awake.Cli.{Options, Runner}

  import ExUnit.CaptureIO

  def run_with_input(pattern, input, opts \\ []) do
    options = option_input_data(pattern, input, opts)
    capture_io(:stdio, fn ->
      Runner.run(options)
    end)
  end
  defp option_input_data(pattern, input, opts \\ []) do
    opts
    |> Keyword.put(:input, input)
    |> Options.from_kwds(pattern)
  end


end
# SPDX-License-Identifier: AGPL-3.0-or-later
