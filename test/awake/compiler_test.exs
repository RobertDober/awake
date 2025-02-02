defmodule Awake.CompilerTest do
  use ExUnit.Case
  alias Awake.State
  doctest Awake.Compiler, import: true

  def comp(pattern) do
    pattern
    |> Awake.Parser.parse 
    |> Awake.Compiler.compile
  end

  def interpret(pattern, opts) do
    functions = comp(pattern)
    output(functions, opts)
  end

  def exec(functions, opts) do
    functions
    |> Enum.reduce(State.new(opts), fn function, state -> function.(state) end)
  end

  def output(functions, opts) do 
    state = exec(functions, opts)
    state.output |> Enum.reverse |> Enum.join("")
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

