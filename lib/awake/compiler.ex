defmodule Awake.Compiler do
  use Awake.Types
  alias Awake.Parser

  @moduledoc ~S"""
  Compiling a pattern to virtual machine instructions

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
      {:outputfld, 0}
      ]

      iex(5)> compile("%-2 %n ((")
      [
      {:outputfld, -2},
      {:outputspc, :n},
      {:outputstr, "("}
      ]

  About seperations

      iex(6)> compile("%-2%n() ((")
      [
      {:outputfld, -2},
      {:outputspc, :n},
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
      {:outputfld, 0},
      {:pushspc, :n},
      {:push, 20},
      {:invoke, :rnd, 1},
      {:invoke, :+, 2},
      ]

  """

  @spec compile(binary()) :: list()
  def compile(pattern) do
    Parser.parse(pattern)
    |> Enum.flat_map(&compile_chunk/1)
  end

  @spec compile_arg(ast_entry_t()) :: list()
  defp compile_arg(arg)

  defp compile_arg({:field, n}) when is_number(n) do
    [{:pushfld, n}]
  end
  defp compile_arg({:field, name}) do
    [{:pushspc, name}]
  end
  defp compile_arg({:s_exp, name, args}), do: compile_s_exp(name, args)
  defp compile_arg(value), do: [{:push, value}]

  @spec compile_args(list()) :: list()
  defp compile_args(args) do
    args
    |> Enum.flat_map(&compile_arg/1)
  end

  @spec compile_chunk(ast_entry_t()) :: list()
  defp compile_chunk(ast)
  defp compile_chunk({:verb, string}), do: [{:outputstr, string}]
  defp compile_chunk({:field, number}) when is_number(number) do
    [{:outputfld, number}]
  end
  defp compile_chunk({:field, name}), do: [{:outputspc, name}]
  defp compile_chunk({:s_exp, name, args}), do: compile_s_exp(name, args)

  @spec compile_s_exp(binary(), list()) :: list()
  defp compile_s_exp(name, args) do
    compile_args(args) ++ [{:invoke, name, Enum.count(args)}]
  end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
