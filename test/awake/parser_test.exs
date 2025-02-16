defmodule AwakeTest.ParserTest do
  use ExUnit.Case
  # doctest Awake.Parser, import: true
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

  describe "mixing in fields" do
    test "the whole line, aka as {:field, 0}" do
      assert parse("%") == [{:field, 0}]
    end
    test "trailing space is ignored" do
      assert parse("% ") == [{:field, 0}]
    end
    test "trailing space is ignored, but only one" do
      assert parse("%  ") == [{:field, 0}, {:verb, " "}]
    end
    test "explicit 0 works too" do
      assert parse("%0") == [{:field, 0}]
    end
    test "0 and name" do
      assert parse("% %hello") ==
        [{:field, 0}, {:field, :hello}]
    end
    test "escapes before fields" do
      assert parse("%%%hello") == [{:verb, "%"}, {:field, :hello}]
    end
    test "names and numbers" do
      assert parse("% %%%hello %3%-2") ==
        [{:field, 0}, {:verb, "%"}, {:field, :hello}, {:verb, " "}, {:field, 3}, {:field, -2}]
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

