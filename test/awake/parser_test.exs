defmodule AwakeTest.ParserTest do
  use ExUnit.Case
  doctest Awake.Parser, import: true
  import Awake.Parser

  test "some wired s_exp" do
    IO.inspect(parse("(% %1 2)")) 
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

