defmodule Ewok do
  
  alias Eowk.Compiler
  @moduledoc ~S"""

  ## Synopsis

  An _awk_ like minilanguage, with a more concise syntax (tailored for command line usage)
  and a little bit less powerful (for now).

  _Ewok_ applies a pattern to each input line.

  The pattern is composed by a sequence of  _verbatim text_, _field_definitions_ and 
  _function_pipelines_.

  If not inhibited by any function in a _function_pipeline_ a default print of the pattern is
  the action at the end of the pattern's application to a line.

  In reality the processus is a little bit more complicated, which will be explained in the
  section [Advanced Patterns](#module-advanced-patterns) below.

  ## Simple Patterns: Fields

  All Fields start with a `%` (use `%%` for a verbatim `%` in the pattern) and have an 
  optional name. It ends with a whitespace or the `%e` (`end_of_pipeline`) field which
  is rendered as an empty string (but also plays an important role in the 
  [Advanced Patterns](#module-advanced-patterns) section

  ### Parts of the line: `%`  and `%`_<n>_
  
  Ressambles to awk's `$‥.` fields, here is an example

    iex(0)> pattern = "% %2%e%-1"
    ...(0)> run(pattern, ["alpha beta gamma", "a b c"])
    ["alpha beta gamma betagamma", "a b c bc"] 
   
  
  ## Advanced Patterns 

  """

  def run(pattern, input) do
    compiled = Compiler.lcompile!(pattern)
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
