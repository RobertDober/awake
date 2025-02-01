defmodule Awake.Compiler do
  @moduledoc ~S"""
  Compiling the AST into a sequence of primitive operations.

  One could imagine that the instructions from the AST to _bytecode_ is as follows

  ```elixir
    compile([{:field, "c"}, {:func, [[:+, 1], [:*, 2]]}, {:verb, " hello"}])
  ```

  would be some bytecode that could be expressed as assambler code similar to this

  ```lisp
    ; :field "c"
    (push_lnb_to_opstack)

    ; :func, [[:+, 1], [:*, 2]]
    (pop_opstack_to_args)
    (push_to_args 1)
    (invoke_builtin :+ 2) ; 2 is the arity, result -> opstack
    (pop_opstack_to_args)
    (push_to_args 2)
    (invoke_builtin :+ 2)
    (duplicate_top_optstack) ; because there is no more function pipeline
    (pop_opstack_to_output)

    ; :verb, " hello"
    (push_to_output " hello")

  ```

  However, this would be overly complicated and not efficent because our runtime is Elixir, therefore
  we compile into primitives which are simply implemented as functions

  ```elixir
    compile([{:field, "c"}, {:func, [[:+, 1], [:*, 2]]}, {:verb, " hello"}])
    # =>
    [
      [&push_lnb_to_opstack/1], 
      [invoke_builtin(:+, [1]), invoke_builtin(:*, [2])],
      [push_to_output(" hello")]
    ]
    # and these functions look approximately like this:
    
    def push_lnb_to_opstack(state), do: %{state | opstack: [state.lnb|state.opstack]}

    def invoke_bultin(name, args, opts \\ []) do
      # checks at compiletime
      fun = Builtins.fetch!(name) # may raise a CompilationError
      # check arity and args here
      fn state ->
        actual_args = [hd(state.opstack)|args]
        result= apply(fun, actual_args)
        %{state | opstack: [result | state.opstack}
      end
    end
  ```

  This is however a little bit more difficult to test and we shall see the results in the doctests
  of the runtime
  """

end
# SPDX-License-Identifier: AGPL-3.0-or-later
