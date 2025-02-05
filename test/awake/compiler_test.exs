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
    opts = Keyword.put_new(opts, :line, "immaterial")
    opts = Keyword.put_new(opts, :name, "start")
    functions
    |> Enum.reduce(State.new(opts), &transition/2)
  end

  def output(functions, opts) do 
    state = exec(functions, opts)
    state.output |> Enum.reverse |> Enum.join("")
  end

  def transition(f, state) do
    show(state)
    show(f.(state))
  end

  def show(%{opstack: opstack, output: output, name: name}=state) do
    if System.get_env("DEBUG") do
      IO.puts(">>> opstack: #{inspect opstack}, output: #{inspect output}, name: #{name}")
    end
    state
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later

