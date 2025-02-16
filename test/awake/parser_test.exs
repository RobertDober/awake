defmodule AwakeTest.ParserTest do
  use ExUnit.Case
  doctest Awake.Parser, import: true
  import Awake.Parser

  describe "simple patterns" do
    test "empty" do
      assert parse("") == []
    end
    test "verbatim is verbatim" do
      assert parse("just me") == [{:verb, "just me"}]
    end
    test "some chars need to be escaped" do
      assert parse("100%% in (()") == [{:verb, "100% in ()"}]
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

