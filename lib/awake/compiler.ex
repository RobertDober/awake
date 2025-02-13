defmodule Awake.Compiler do
  use Awake.Types

  @moduledoc ~S"""
  Compiles the Bytecode into a function which then will transform the input state for each line into an output state

  In these examples we will use a helper to compile the pattern to the ast and then the bytecode, generate the input state
  with a line and linenumber and only return the output

  """


  @doc ~S"""
  """

  @spec compile(ast_t()) :: symbolic_code()
  defdelegate compile(chunks), to: Awake.Compiler.CompilerImplementation

end
# SPDX-License-Identifier: AGPL-3.0-or-later
