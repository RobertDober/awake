defmodule Awake.Compiler do
  use Awake.Types
  alias Awake.{Opcode, Parser}

  import Opcode

  @moduledoc ~S"""
  Compiling a pattern to virtual machine instructions

  Virtual machine instructions are `Opcode` objects which are shown below
  as their visual representation. When the runtime executes these instructions
  it optimizes them by only extratcting the `fun` field from the `Opcode` objects.

  ## Simple patterns

      iex(1)> compile("")
      []

  ### Verbatim

      iex(2)> compile("hello world")
      [
      {:outputstr, "hello world"},
      ]

  Optimized

      iex(3)> compile("100%%")
      [
      {:outputstr, "100%"},
      ]

  ### Fields

      iex(4)> compile("%")
      [
      {:outputline}
      ]

      iex(5)> compile("%-2 %n ((")
      [
      {:outputfld, -2},
      {:outputspc, :lnb},
      {:outputstr, "("}
      ]

  About seperations

      iex(6)> compile("%-2%n() ((")
      [
      {:outputfld, -2},
      {:outputspc, :lnb},
      {:outputstr, " ("}
      ]

  ### S-Expressions

      iex(7)> compile("(rnd 10)")
      [
      {:push, 10},
      {:invoke, :rnd, 1} 
      ]

      iex(8)> compile("%(+ %n (rnd 20))")
      [
      {:outputline},
      {:pushspc, :lnb},
      {:push, 20},
      {:invoke, :rnd, 1},
      {:invoke, :+, 2},
      ]

  """

  @spec compile(binary(), boolean()) :: list()
  def compile(pattern, symbolic_only \\ true) do
    chunks =  Parser.parse(pattern)
      |> Enum.flat_map(&compile_chunk/1)
    if symbolic_only do
      chunks
      |> Enum.map(&representation/1)
    else
      chunks
      |> Enum.map(&Map.get(&1, :function))
    end
  end

  @spec compile_arg(ast_entry_t()) :: list()
  defp compile_arg(arg)

  defp compile_arg({:field, n}) when is_number(n) do
    makeary(:pushfld, n)
  end
  defp compile_arg({:field, name}) do
    makeary(:pushspc, name)
  end
  defp compile_arg({:s_exp, name, args}), do: compile_s_exp(name, args, false)
  defp compile_arg(value), do: makeary(:push, value)

  @spec compile_args(list()) :: list()
  defp compile_args(args) do
    args
    |> Enum.flat_map(&compile_arg/1)
  end

  @spec compile_chunk(ast_entry_t()) :: list()
  defp compile_chunk(ast)
  defp compile_chunk({:verb, string}), do: makeary(:outputstr, string)
  defp compile_chunk({:field, 0}), do: makeary(:outputline, [])
  defp compile_chunk({:field, number}) when is_number(number) and number > 0 do
    makeary(:outputfld, number - 1)
  end
  defp compile_chunk({:field, number}) when is_number(number) do
    makeary(:outputfld, number)
  end
  defp compile_chunk({:field, name}), do: make_special(name, :out)
  defp compile_chunk({:s_exp, name, args}), do: compile_s_exp(name, args, true)

  @spec compile_s_exp(binary(), list(), boolean()) :: list()
  defp compile_s_exp(name, args, outer) do
    invocation = 
      if outer do
        invoke_to_out(name, Enum.count(args))
      else
        invoke_to_stack(name, Enum.count(args))
      end
    compiled_args = compile_args(args)
    compiled_args ++ invocation
  end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
