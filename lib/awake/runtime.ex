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

    Here we see an example of why we might want to duplicate more than one
    value, this also shows how things are popped of the stack, we also need
    to understand that the `(d)` function will also pull off the top of the
    stack to output, if we do not want this we can use `(i)` as demonstrated
    below, therefore the following pattern will, when executed, do the
    following things to the stack and output assuming the input being `"32 10"`
    again:

          "%1(d 2)..."    stack: [32, 32],         out: [32]
          "%2(d 2)..."    stack: [10, 10, 32, 32]  out: [10, 32]
          "( jjj



  """

  @spec run(any(), binary(), non_neg_integer()) :: binary?()
  defdelegate run(compiled, line, lnb), to: Awake.Runtime.RuntimeImplementation
end
# SPDX-License-Identifier: AGPL-3.0-or-later
