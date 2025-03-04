defmodule Test.Awake.Compiler.CompilerTest do
  use Support.CompilerTestCase

  describe "basic field, input line" do
    check_compilation "%", [{:outputline}]

    describe_result "%", "input line" do
      assert ["input line"] == result.output
    end
  end

  describe "a subfield, verbatim text and line count" do
    check_compilation "%2  some text%n",
    [{:outputfld, 1}, {:outputstr, " some text"}, {:outputspc, :lnb}]

    describe_result "%2  some text%n", "alpha beta" do
      assert [0, " some text", "alpha"] 
    end

    # Let's change the line number
    describe_result "%2  some text%n", "alpha beta", 42 do
      assert [42, " some text", "alpha"] 
    end
  end

  describe "negative field and timestamps" do
    check_compilation "Last%-1 %s %x %xm",
    [{:outputstr, "Last"}, {:outputfld, -1}, {:outputspc, :tsec}, {:outputspc, :xsec}, {:outputspc, :xmillis}]

    describe_result "%-1 %s %x %xm", "alpha beta" do
      secs = div(result.start_ts, 1_000_000)
      xsec = secs |> Integer.to_string(16)
      xmil = div(result.start_ts, 1_000) |> Integer.to_string(16)
      assert [xmil, xsec, secs, "beta"]
    end
  end

#   check_compilation "%1 %n", "hello world",
#   [{:outputfld, 0}, {:outputspc, :lnb}], 
#     "hello0"

#   check_compilation "Hello: %-1", "universe",
#   [{:outputstr, "Hello: "}, {:outputfld, -1}],
#     "Hello: universe"

#   check_compilation "
#   describe_result "Hello: %s", "" do
#     secs = div(result.start_ts, 1_000_000)
#     assert [secs, "Hello: "] == result.output
#   end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
