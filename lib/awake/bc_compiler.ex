defmodule Awake.BcCompiler do
  use Awake.Types

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
  <<"invoke  ", 32::size(16), 2::size(16)>>
  ```

  Note the fixed size (64 bit) encoding of the opcode, the representation of the builtin as an address
  into a list of functions and the arity of the function

  This allows the compiler to decode the bytecodes efficently

  ```elixir
    case bytecode do
    <<opcode :: binary-size(8), rest :: binary>> -> ...
  ```

  """


  @doc ~S"""
  compiles the ast into symbolic code

  ## Verbatims

  We use a helper (`comp`) defined in the tests which compiles the pattern before it passing into compile

      iex(1)> comp("hello world")
      [
      {:strtoout, "hello world"} 
      ]

      iex(2)> comp("(( %%")
      [
      {:strtoout, "( %"} 
      ]

  ## Fields

      iex(3)> comp("%")
      [
      {:fieldout, 0}
      ]

      iex(4)> comp("%2 %-1 %c")
      [
      {:fieldout, 2},
      {:strtoout, " "},
      {:fieldout, -1},
      {:strtoout, " "},
      {:lnbtoout}
      ]

  As a matter of fact each predefined field has a dedicated opcode (actually two as we will see below, when they
        preceed a pipeline)


      iex(5)> comp("%ctm()%ct()%cxm()%cx()%tm()%t()%xm()%x")
      [
      {:ctmtoout},
      {:ctstoout},
      {:cxmtoout},
      {:cxstoout},
      {:stmtoout},
      {:ststoout},
      {:sxmtoout},
      {:sxstoout},
      ]

  ## Pipelines
  
  Now let us create the code for adding one to each of these fields

      iex(6)> comp("%ctm(+ 1)%ct(+ 1)%cxm(+ 1)%cx(+ 1)%tm(+ 1)%t(+ 1)%xm(+ 1)%x")
      [
      {:ctmtostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2}, # 0 is a pointer to the built in function, and 2 is the arity
      {:ctstostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      {:cxmtostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      {:cxstostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      {:stmtostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      {:ststostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      {:sxmtostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      {:sxstostk},
      {:pshtostk, 1},
      {:invkstk, 0, 2},
      ]

  """

  @spec compile(ast_t()) :: symbolic_code()
  defdelegate compile(chunks), to: Awake.BcCompiler.Implementation

end

# SPDX-License-Identifier: AGPL-3.0-or-later
