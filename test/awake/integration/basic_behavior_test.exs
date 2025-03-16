defmodule Test.Awake.Integration.BasicBehaviorTest do
  use Support.IntegrationTestCase

  describe "verbatim" do
    test "empty" do
      result = run_with_input("something", [])
      assert "" == result
    end
    test "some lines" do
      result = run_with_input("something", ~w[a a a])
      assert lines(~W[something something something]) == result
    end
    test "more strings" do
      result = run_with_input("something%%((", ~w[a])
      assert lines(~W[something%(]) == result
    end
  end

  describe "fields" do
    # test "the whole line" do
    #   result = run_with_input("%", ~W[alpha beta]) 
    #   assert lines(~W[alpha beta]) == result
    # end
    test_run "%1 %2  %3", ["\n"], []
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
