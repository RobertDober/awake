defmodule Awake do
  use Awake.Types

  alias Awake.{Compiler, Parser}

  @moduledoc ~S"""
  ## Synopsis

  An _awk_ like 'mini language', with a more concise syntax (tailored for command line usage)
  and a little bit less powerful (for now).

  _Awake_ applies a pattern to each input line. The pattern is composed by a sequence of _chunks_, where each _chunk_ is either
  some _verbatim text_, a _field_definition_ or a _function_pipeline_. 

  If not inhibited by any function in a _function_pipeline_ a default behavor is to print the result of
  this application to `$stdout`.

  As a matter of fact each _chunk_ will be compiled to a function which operates on a _state_.

  Then, the runtime will execute this list of compiled _chunks_ as follows.

      LOOP1: for each line
            create a new state containing:
                - an empty operand stack (`opstack`)
                - an empty output stack (`output`)
                - the, chomped, line (`line`)
                - all whitespace seperated fields of the line (`fields`) à la _awk_
                - the number of the input line, starting with 0 (`lnb`)
  
            LOOP2: for each chunk
                - call the compiled chunk (it is responsible to update the state)
                - goto LOOP1 if the result of the call above equals `:abort`
                - print the concatenation of `output` to `$stdout` (with a trailing newline)


  ### A simple example

  Let us consider the following, simple pattern: `"%  %1-hello %c(+ 1)"`
  This pattern can be described by the following _pseudo functions_

      % => push `input` onto `opstack` and `output`
      ws and other verbatim text like `"-hello"` =>
            push itself onto `output`
      %1 => like %, but for `fields[0]`
      %c => like %, but for `lnb`

  However if a field (or a function) is followed by another function, then only the last
  one will modify `output`.

  Therfore the compilation of the chunk 

      "%c(..." => push `lnb` onto `opstack`
      "(+ 1)" =>  pop value from `opstack`, push result onto `opstack`, push result onto `output`
                    (because we are the tail of the pipeline)


  ### Simple Patterns: Fields

  All Fields start with a `%` (use `%%` for a verbatim `%` in the pattern) and have an 
  optional name. It ends with a white space or the `%e` (`end_of_pipeline`, or `epsilon`) field which
  is rendered as an empty string and can also interrupt a pipeline.

  ### Complex Patterns: Function Pipelines (aka _pipelines_)

  If a fieled is followed by a list of lisp s-expressions the whole together forms a _pipeline_.
  As indicated by the name this will be interpreted as a pipeline of functions with the field value
  injected into it.

  ### Simple Patterns: Verbatim text

  All text not containing a `%` or a `(` is verbatim text, and as mentioned above `%%` and `((` will
  be parsed as verbatim text containung `%` and `(` respectively.


  ## Implementation

  This is implemented in 3 phases

  ### Parser

  It parses a pattern into an _Abstract Syntax Tree_ (aka _AST_). Here is an example

  ```elixir
      "%ts hello %%"
  ```

  becomes

  ```elixir
      [{:field, "ts"], {:verb "hello"}, # N.B. the first space is missing
       {:verb, "%"}]
  ```

  For a detailed description refer to the [doctests of the Parser](awake.Parser.html)

  ### Compiler

  It will compile the AST into functions

  e.g.

  ```elixir
        {:verb, "some_text"}
  ```

  becomes

    ```elixir
      fn state ->
        %{state | output: [state.output, "some_text"]}
      end
    ```

  while the more complex
  ```elixir
        [{:field, 1}, {:fun, "+", [1]}]
  ```

  becomes something like

      f1 = fn state ->
              %{state | opstack: [fields[0]]|opstack]} end

      f2 = fn state ->
              [arg, opstack1] = opstack
              %{state | opstack: [(to_number(arg) + 1) | opstack]} end

      [f1, f2] |> Enum.reduce(state, fn f -> f.(state) end)
      %{state | output = [state.output, head(state.opstack)]

  For a detailed description refer to the [doctests of the Compiler](awake.Compiler.html)
  """

  @spec run(binary()) :: binaries()
  def run(pattern) do
    {:ok, ast} = Parser.parse(pattern)
    instructions = Compiler.compile(ast)
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
