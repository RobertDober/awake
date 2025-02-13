defmodule Test.Awake.RuntimeTest do
  use ExUnit.Case
  doctest Awake.Runtime, import: true
  import Awake.{Runtime, State}

  defp crun(pattern, opts \\ []) do
    pattern
    |> Awake.Parser.parse 
    # |> IO.inspect(label: :ast)
    |> Awake.Compiler.compile
    # |> IO.inspect(label: :compiled)
    |> run(Keyword.get(opts, :line, "Just a line"), Keyword.get(opts, :lnb, 42))
    # |> IO.inspect(label: "run result")
  end

  defp output(pattern, opts \\ []) do
    crun(pattern, opts).output
  end

  describe "verbatim" do
    test "constant" do
      assert crun("constant") == "constant"
    end
    
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
