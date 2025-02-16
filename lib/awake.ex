defmodule Awake do
  use Awake.Types

  # alias Awake.{Compiler, Parser}
  alias Awake.Parser

  @moduledoc ~S"""
  ## Synopsis

    Coming Soon for v0.2

  """

  @spec run(binary()) :: binaries()
  def run(_pattern) do
    # ast = Parser.parse(pattern)
    # Compiler.compile(ast)
    # instructions = Compiler.compile(ast)
    []
  end

  @doc false
  @spec parse(binary()) :: ast_t()
  defdelegate parse(pattern), to: Parser 

end
# SPDX-License-Identifier: AGPL-3.0-or-later
