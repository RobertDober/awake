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
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
