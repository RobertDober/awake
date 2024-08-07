defmodule Test.CompilerTest do
  use ExUnit.Case
  import Ewok.Compiler

  describe "compiled verbatim patterns" do
    test "an escaped %" do
      assert compile!("%%") == ["%"]
    end

    test "just a string" do
      subject = "just a string"
      assert compile!(subject) == [subject]
    end

    test "combination of them" do
      assert compile!("%%hello%%") == ["%", "hello", "%"] 
    end
  end

  describe "fields" do
    test "just the whole thing" do
      assert compile!("%") == [{:%, 0}]
    end
    test "explicitly the whole thing" do
      assert compile!("%0") == [{:%, 0}]
    end
    test "or any field" do
      assert compile!("%4") == [{:%, 4}]
    end
    test "counting from the end" do
      assert compile!("%-42") == [{:%, -42}]
    end
  end

  describe "fields and verbatims" do
    test "hello 1" do
      assert compile!("hello%1") == ["hello", {:%, 1}] 
    end
    test "hello 2" do
      assert compile!("%hello%2%e") == [{:%, 0}, "hello", {:%, 2}, {:e}] 
    end
  end
  
end
# SPDX-License-Identifier: AGPL-3.0-or-later
