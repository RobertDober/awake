defmodule Awake.BcCompiler do
  @moduledoc ~S"""
  Compiles the AST into bytecode.

  There are two phases, the first, `compile` creates a human readable representation of
  the bytecode, which is also interpreted by the compiler to create the final code.

  The second one, `encode` is used to transform the representation into actual bytecode
  which is ideal for machine consumption. This allows to store the bytecode in files
  and execute awake with the `-f|--file` switch.

  If we compile the following pattern "%1 %c(+ 1)" and compile it we will get something like
  the following

  ```elixir
  [
      {:fieldout, 1},
      {:fieldstk, :c},
      {:pushstk, 1},
      {:invoke, :+, 2}

  ]
  ```

  which, when passed to `encode` will return a list of encoded tuples, the `:invoke` tuple would be
  encoded like this:

  ```elixir
  <<105, 110, 118, 111, 107, 101, 32, 32, 0, 32, 0, 2>> # which corresponds to
  "invoke  ", 32::size(16), 2::size(16)>>
  """

  Note the fixed size (64 bit) encoding of the opcode, the representation

end
# SPDX-License-Identifier: AGPL-3.0-or-later
