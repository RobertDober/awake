defmodule Awake.Parser do
  use Awake.Types

  alias Minipeg.Parser
  alias Awake.Grammar

  @moduledoc ~S"""
  Parse a pattern into an AST
  """

  @doc ~S"""
  Parses the pattern

  ### Verbatim chunks

  If we want to print a fixed text for each line of input from stdin, we can use
  a verbatim pattern

      iex(1)> parse("hello world")
      [{:verb, "hello world"}]

  but need to escape `%`

      iex(2)> parse("%%")
      [{:verb, "%"}]

  and also "("

      iex(3)> parse("((")
      [{:verb, "("}]

  verbs are glued together

      iex(4)> parse("hello ((%%")
      [{:verb, "hello (%"}]

  ### Field chunks

  verbs are seperated by fields

      iex(5)> parse("hello %c and more%%")
      [{:verb, "hello "}, {:field, "c"}, {:verb, " and more%"}]

  fields are either predefined, or indices into fields

      iex(6)> parse("%c%tm%2%-1%t or %")
      [{:field, "c"}, {:field, "tm"}, {:field, 2}, {:field, -1}, {:field, "t"},  {:verb, " or "}, {:field, 0}]

  ### Ambigous patterns

  Assumeing we want to parse the input into `[{:field, 0}, {:field, 0}]`
  but, `"%%"` would be parsed into `[{:verb, "%"}]`.

  And we want to parse the input into `[{:field, "t"}, {:verb, "s"}]` but `"%ts"` would be parsed into `[{:field, "ts"}]`

  How can we fix this?

  Enter the empty function, "`()`"

  **N.B.** that we can get `[{:verb, "()"}]` easily enough from
  the input `"(()"` and also that it is not part of the ast.

      iex(7)> parse("%()%")
      [{:field, 0}, {:field, 0}]

      iex(8)> parse("%t()s")
      [{:field, "t"}, {:verb, "s"}]

  ### Function Pipelines

  The syntax of function pipelines is simply a list of s-expressions, however
  the preceding field is integrated into the function ast tuple

      iex(9)> parse("%(+ 1 2)(tos 16) %c(lpad 5 0)")
      [{:pipe, 0,  [[:+, 1, 2],  [:tos, 16]]}, {:verb, " "}, {:pipe, "c",  [[:lpad, 5, 0]]}]

  N.B. that inside a function `%` is just `%`

      iex(10)> parse("%(% 2)")
      [{:pipe, 0,  [[:%, 2]]}]

  """
  @spec parse(binary()) :: augmented_t()
  def parse(pattern) do
    with {:ok, ast} <- Parser.parse_string(Grammar.pattern, pattern) do
      combine_chunks(ast)
    end
  end

  @spec combine_chunks(ast_t(), ast_t()) :: augmented_t()
  defp combine_chunks(ast, result \\ [])
  defp combine_chunks([], result), do: Enum.reverse(result)
  defp combine_chunks([{:field, field}, {:func, args} | rest], result) do
    combine_chunks(rest, [{:pipe, field, args}|result])
  end
  defp combine_chunks([h|t], result), do: combine_chunks(t, [h|result])

end
# SPDX-License-Identifier: AGPL-3.0-or-later
