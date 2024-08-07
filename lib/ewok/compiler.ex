defmodule Ewok.Compiler do
  use Ewok.Types

  import Minipeg.Parser, only: [parse_string: 2]

  alias Ewok.Compiler.Parsers, as: P
  import Minipeg.{Combinators, Parsers}

  @moduledoc ~S"""
  Compiles a pattern into an AST
  """

  @spec compile(binary()) :: result_t(ast_t())
  def compile(pattern) do
    parse_string(P.pattern_parser,pattern)
  end

  @spec compile!(binary()) :: ast_t()
  def compile!(pattern) do
    case parse_string(P.pattern_parser,pattern) do
      {:ok, ast} -> ast
      {:error, message} -> raise message
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
