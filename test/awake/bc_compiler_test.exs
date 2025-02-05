defmodule Awake.BcCompilerTest do
  use ExUnit.Case
  doctest Awake.BcCompiler, import: true

  def comp(pattern) do
    pattern
    |> Awake.Parser.parse 
    |> Awake.BcCompiler.compile
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later

