defmodule Awake.CompilerTest do
  use ExUnit.Case
  doctest Awake.Compiler, import: true

  def comp(pattern) do
    pattern
    |> Awake.Parser.parse 
    |> Awake.Compiler.compile
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

