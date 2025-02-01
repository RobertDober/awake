defmodule Awake.Parser do
  use Awake.Types

  alias Minipeg.Parser
  alias Awake.Grammar
  import Minipeg.{Combinators, Mappers, Parsers}

  @moduledoc ~S"""
  Parse a pattern into an AST
  """

  @doc ~S"""
  Parses the pattern

  ### Verbatim chunks

  If we want to print a fixed text for each line of input from stdin, we can use
  a verbatim pattern

      iex(1)> parse("hello world")
      {:ok, [{:verb, "hello world"}]}

  but need to escape `%`

      iex(2)> parse("%%")
      {:ok, [{:verb, "%"}]}

  and also "("

      iex(3)> parse("((")
      {:ok, [{:verb, "("}]}

  verbs are glued together

      iex(4)> parse("hello ((%%")
      {:ok, [{:verb, "hello (%"}]}

  ### Field chunks

  verbs are seperated by fields

      iex(5)> parse("hello %c and more%%")
      {:ok, [{:verb, "hello "}, {:field, "c"}, {:verb, " and more%"}]} 

  fields are either predefined, or indices into fields

      iex(6)> parse("%c%tm%2%-1%t or %")
      {:ok, [{:field, "c"}, {:field, "tm"}, {:field, 2}, {:field, -1}, {:field, "t"},  {:verb, " or "}, {:field, 0}]}

  ### Ambigous patterns

  Assumeing we want to parse the input into `[{:field, 0}, {:field, 0}]`
  but, `"%%"` would be parsed into `[{:verb, "%"}]`.

  And we want to parse the input into `[{:field, "t"}, {:verb, "s"}]` but `"%ts"` would be parsed into `[{:field, "ts"}]`

  How can we fix this?

  Enter the empty function, "`()`"

  **N.B.** that we can get `[{:verb, "()"}]` easily enough from
  the input `"(()"` and also that it is not part of the ast.

      iex(7)> parse("%()%")
      {:ok, [{:field, 0}, {:field, 0}]}

      iex(8)> parse("%t()s")
      {:ok, [{:field, "t"}, {:verb, "s"}]}

  ### Function Pipelines

  The syntax of function pipelines is simply a list of s-expressions

      iex(9)> parse("%(+ 1 2)(tos 16) %c(lpad 5 0)")
      {:ok, [{:field, 0}, {:func, [[:+, 1, 2],  [:tos, 16]]}, {:verb, " "}, {:field, "c"}, {:func, [[:lpad, 5, 0]]}]}

  """
  @spec parse(binary()) :: Parser.result_tuple_t(ast_t())
  def parse(pattern) do
    Parser.parse_string(Grammar.pattern, pattern)
  end


end
# SPDX-License-Identifier: AGPL-3.0-or-later
