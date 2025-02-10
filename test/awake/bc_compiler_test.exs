defmodule Awake.BcCompilerTest do
  use ExUnit.Case
  doctest Awake.BcCompiler, import: true
  alias Awake.Exceptions.CompilationError
  import Awake.BcCompiler

  def comp(pattern) do
    pattern
    |> Awake.Parser.parse 
    |> Awake.BcCompiler.compile
  end

  describe "compilation errors" do
    test "field with bad type" do
      assert_raise CompilationError, fn ->
        compile([{:field, :hello}])
      end
    end
  end

  describe "complete" do
    test "numeric field" do
      assert compile([{:field, 2}]) == [{:field, 2}]
    end
    test "numeric pipe" do
      assert compile([{:pipe, -3, [[:%, 2]]}]) ==
        [
          {:field, -3},
          {:push, 2},
          {:invoke, 2, :%}
        ]
    end
  end

  describe "some arity checks" do
    test "croaks if too many params are provided"  do
      assert_raise CompilationError, fn ->
        compile([{:pipe, :c, [[:+, 2, 3]]}])

      end
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

