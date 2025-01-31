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

  If we want to print a fixed text for each line of input from stdin, we can use
  a verbatim pattern

      iex(1)> parse("hello world")
      {:ok, [{:verb, "hello world"}]}

  but need to escape `%`

      iex(2)> parse("%%")
      {:ok, [{:verb, "%"}]}

  and also "("

      iex(2)> parse("((")
      {:ok, [{:verb, "("}]}

  """
  @spec parse(binary()) :: Parser.result_tuple_t(ast_t())
  def parse(pattern) do
    Parser.parse_string(Grammar.pattern, pattern)
  end


end
# SPDX-License-Identifier: AGPL-3.0-or-later
