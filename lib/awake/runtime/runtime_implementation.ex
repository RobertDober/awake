defmodule Awake.Runtime.RuntimeImplementation do
  use Awake.Types

  alias Awake.State
  @moduledoc false


  @spec run(any(), binary(), non_neg_integer()) :: binary?()
  def run(compiled, line, lnb) do
    # IO.inspect(compiled 
    case compiled |> Enum.reduce_while(State.new(line: line, lnb: lnb), &apply_fun/2) do
      %State{ignore: true} -> nil
      %State{output: out} -> out |> Enum.reverse |> Enum.join
    end
  end

  defp apply_fun(fdesc, %State{output: out}=state) do
    result = invoke(fdesc, state)
    # IO.inspect(result, label: "applied function"j
    case result do
      %State{opstack: [h|t], output: out}=state -> {:cont, %{state|opstack: t, output: [h|out]}}
      # output when is_binary(output) -> IO.inspect({:cont, %{state|output: [output|out]}}, label: "output")
      output when is_binary(output) -> {:cont, %{state|output: [output|out]}}
      {:halt, _}=halted -> halted
    end
  end

  defp call_fun_from_stack(fun, %State{opstack: opstack}=state, arity) do
    args = Enum.take(opstack, arity)
    opstack = Enum.drop(opstack, arity)
    result = apply(fun, args)
    %{state|opstack: [result|opstack]} 
  end

  defp invoke(fun, state) do
    case fun do
      {0, f} -> f.(state)
      {arity, f} -> call_fun_from_stack(f, state, arity)
      fun -> fun.(state)
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
