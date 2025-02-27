defmodule Test.Awake.ParserSynatxErrorTest do
  use ExUnit.Case
  import Awake.Parser

  describe "s_exp" do
    test "do not allow s-expressions at the function position" do
      message = "unexpected s_exp_entry (a) 42)"
      assert_raise(Awake.Exceptions.SyntaxError, message, fn -> parse("( (a) 42)") end)
    end
    test "missing closing paren" do
      message = "unexpected end of input in s-expression"
      assert_raise(Awake.Exceptions.SyntaxError, message, fn -> parse("(") end)
    end
    test "missing closing paren after args" do
      message = "unexpected end of input in s-expression"
      assert_raise(Awake.Exceptions.SyntaxError, message, fn -> parse("(+ (* 3 2)") end)
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
