defmodule Support.CompilerTestCase do
  @moduledoc ~S"""

  """
  defmacro __using__(_opts \\ []) do
    quote do
      use ExUnit.Case
      import Awake.Compiler
      alias Awake.{Runtime, State}

      def comp(pattern) do
        {
          compile(pattern, true),
          compile(pattern, false),
        }
      end

      def run(compiled, line, lnb \\ 1) do
        functions = compiled[:code]
        state = State.new(line: line, start_ts: 1740856140563029) # corresponds roughly to UTC 20250301T190900.562816
        Runtime.run(state, functions)
      end
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
