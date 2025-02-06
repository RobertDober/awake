defmodule Awake.BcCompiler do
  use Awake.Types

  @moduledoc ~S"""
  Compiles the AST into bytecode.

  There are two phases, the first, `compile` creates a human readable representation of
  the bytecode, which is also interpreted by the compiler to create the final code.

  The second one, `encode` is used to transform the representation into actual bytecode
  which is ideal for machine consumption. This allows to store the bytecode in files
  and execute awake with the `-f|--file` switch.

  """


  @doc ~S"""
  compiles the ast into symbolic code

  ## Verbatims

  We use a helper (`comp`) defined in the tests which compiles the pattern before it passing into compile

      iex(1)> comp("hello world")
      [
      {:verb, "hello world"} 
      ]

      iex(2)> comp("(( %%")
      [
      {:verb, "( %"} 
      ]

  ## Fields

      iex(3)> comp("%")
      [
      {:field, 0}
      ]

      iex(4)> comp("%2 %-1 %c")
      [
      {:field, 2},
      {:verb, " "},
      {:field, -1},
      {:verb, " "},
      {:lnb}
      ]

  As a matter of fact each predefined field has a dedicated opcode (actually two as we will see below, when they
        preceed a pipeline)


      iex(5)> comp("%ctm()%ct()%cxm()%cx()%tm()%t()%xm()%x")
      [
      {:ctm},
      {:cts},
      {:cxm},
      {:cxs},
      {:stm},
      {:sts},
      {:sxm},
      {:sxs},
      ]

  ## Pipelines
  
  Now let us create the code for adding one to each of these fields

      iex(6)> comp("%ctm(+ 1)%ct(+ 1)%cxm(+ 1)%cx(+ 1)%tm(+ 1)%t(+ 1)%xm(+ 1)%x(+ 3)")
      [
      {:ctm},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:cts},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:cxm},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:cxs},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:stm},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:sts},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:sxm},
      {:push, 1},
      {:invoke, 2, :+}, # 2 is the arity
      {:sxs},
      {:push, 3},
      {:invoke, 2, :+}, # 2 is the arity
      ]

  """

  @spec compile(ast_t()) :: symbolic_code()
  defdelegate compile(chunks), to: Awake.BcCompiler.Implementation

end

# SPDX-License-Identifier: AGPL-3.0-or-later
