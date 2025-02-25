defmodule AwakeTest.ParserTest do
  use ExUnit.Case
  # doctest Awake.Parser, import: true
  import Awake.Parser

  describe "simple patterns" do
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
    test "field at the end" do
      assert parse(" %") == [{:verb, " "}, {:field, 0}]
    end
    test "trailing space is ignored, but only one" do
      assert parse("%  ") == [{:field, 0}, {:verb, " "}]
    end
    test "explicit 0 works too" do
      assert parse("%0") == [{:field, 0}]
    end
    test "0 and name" do
      assert parse("% %ctm") ==
        [{:field, 0}, {:field, :ctm}]
    end
    test "escapes before fields and normalisation of names" do
      assert parse("%%%ct") == [{:verb, "%"}, {:field, :cts}]
    end
    test "names and numbers" do
      assert parse("% %%%c %3%-2") ==
        [{:field, 0}, {:verb, "%"}, {:field, :lnb}, {:field, 3}, {:field, -2}]
    end
    test "seperation of fields with spaces and normalisation of names" do
      assert parse("%1 hello%tm again") ==
        [{:field, 1}, {:verb, "hello"}, {:field, :stm}, {:verb, "again"}]
    end
  end

  describe "functions" do
    test "the null s-expression (use case: unclear)" do
      assert parse("()") ==[] 
    end

    test "a zero arity function" do
      assert parse("(mod)") ==
        [{:func, :mod, []}]
    end

    test "some args" do
      assert parse("(lpad 0 5)") ==
        [{:func, :lpad, [0, 5]}]
    end

    test "zero arity-functions" do
      assert parse("(+)(%)(mod)") ==
        [{:func, :+, []}, {:func, :%, []}, {:func, :mod, []}]
    end

    test "args as fields" do
      assert parse("(+ %c 1)") ==
        [{:func, :+, [{:field, :c}, 1]}]
    end

    test "some complex stuff" do
      result = parse("(lpad (+ %ctm (* 1000 %c)) 5 '')")
      assert result == [
        {:func, :lpad, [:+, [{:field, :ctm}, [:*, 1_000, {:field, :lnb}], 5, ""]]} 
      ]
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

