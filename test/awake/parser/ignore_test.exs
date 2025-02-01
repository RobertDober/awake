defmodule AwakeTest.Parser.IgnoreTest do
  use ExUnit.Case
  import Minipeg.{Combinators, Parser, Parsers}
  describe "ignore" do
    test "is not part of the ast" do
      parser = many(select([
        literal_parser("a"),
        literal_parser("b") |> ignore(),
      ]))
      assert parse_string(parser, "ababb") == {:ok, ["a", "a"]}
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

