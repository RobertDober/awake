defmodule Awake.Compiler.VerbTest do
  use ExUnit.Case
  import Awake.Compiler

  describe "a single verb" do
    test "empty" do
      assert compile([]) == []
    end
    test "normal case" do
      assert compile([{:verb, "hello"}]) == ["pshouthello"]
    end
    test "while this should not happen it still should be handled" do
      ast = [
        {:verb, "hello"},
        {:verb, " world"},
      ]
      assert compile(ast) == ["pshouthello", "pshout world"]
    end
  end
    
end
# SPDX-License-Identifier: AGPL-3.0-or-later

