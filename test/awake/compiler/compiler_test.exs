defmodule Test.Awake.Compiler.CompilerTest do
  use Support.CompilerTestCase

  setup :compile_pattern

  describe "simple field" do
    @pattern "%"
    test "whole line", compiled do
      assert compiled[:symbolic] == [{:outputline}]
    end
    test "functional", compiled do
      result = run(compiled, "hello line")
      assert result.output == ["hello line"]
    end
  end

  describe "field and line number" do
    @pattern "%1 %n"
    test "symbolic", compiled do
      assert compiled[:symbolic] == [{:outputfld, 0}, {:outputspc, :lnb}]
    end
    test "functional", compiled do
      result = run(compiled, "hello line")
      assert result.output == [1, "hello"]
    end
  end

  defp compile_pattern(_) do
    {symbolic, func} = comp(@pattern)
    [code: func, symbolic: symbolic]
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
