defmodule Test.Awake.ErrorParserTest do
  use ExUnit.Case
  import Awake.Parser
  describe "errors" do
    test "empty" do
      assert parse("") == 
        {:error, "Missing 1 parses in many (in pattern parser) in <binary>:1,1"}
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
