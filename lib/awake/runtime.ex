defmodule Awake.Runtime do
  use Awake.Types

  @moduledoc ~S"""
  Runs a compiled pattern against an input line and linenumber, here we
  use a helper, which compiles a pattern, creates an input state and returns the
  output of the resulting state

  ```elixir
      def output(pattern, line: 'Just a line', lnb: 42) do
        compiled = pattern |> parse  |> compile
        run(compiled, line, lnb).output
      end

  ```
  """

  @doc ~S"""
  ## The simplest of them all

      iex(1)> crun("Hello World")
      "Hello World"

  
      iex(2)> crun("Hello()World")
      "HelloWorld"

  """

  @spec run(any(), binary(), non_neg_integer()) :: binary?()
  defdelegate run(compiled, line, lnb), to: Awake.Runtime.RuntimeImplementation
end
# SPDX-License-Identifier: AGPL-3.0-or-later
