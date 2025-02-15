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
  ## The simplest of them all: Verbatim Text

      iex(1)> crun("Hello World")
      "Hello World"

  
      iex(2)> crun("Hello()World")
      "HelloWorld"

  ## Not very complicated: numeric fields
  
      iex(3)> crun("%2 % %-1", line: "  alpha beta gamma ")
      "beta   alpha beta gamma  gamma"

  ## Now just let's compute

    `(d <n>)` duplicates the top of the stack `<n>` times
    where `<n>` defaults to 1
    and then we use the stack to add the two fields
  
      iex(4)> crun("%1(d) + %2(d) = (+)", line: "32 10")
      "32 + 10 = 42"

  """

  @spec run(any(), binary(), non_neg_integer()) :: binary?()
  defdelegate run(compiled, line, lnb), to: Awake.Runtime.RuntimeImplementation
end
# SPDX-License-Identifier: AGPL-3.0-or-later
