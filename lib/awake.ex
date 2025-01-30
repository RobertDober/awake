defmodule Awake do
  use Awake.Types

  alias Awake.Compiler
  @moduledoc ~S"""

  ## Synopsis

  An _awk_ like 'mini language', with a more concise syntax (tailored for command line usage)
  and a little bit less powerful (for now).

  _Awake_ applies a pattern to each input line.

  The pattern is composed by a sequence of  _verbatim text_, _field_definitions_ and 
  _function_pipelines_.

  If not inhibited by any function in a _function_pipeline_ a default print of the pattern is
  the action at the end of the pattern's application to a line.

  ## Simple Patterns: Fields

  All Fields start with a `%` (use `%%` for a verbatim `%` in the pattern) and have an 
  optional name. It ends with a white space or the `%e` (`end_of_pipeline`, or `epsilon) field which
  is rendered as an empty string and can also interrupt a pipeline

  ### Parts of the line: `%`  and `%`_<n>_
  
  Resembles to awk's `$‥.` fields, here is an example

    iex(0)> pattern = "% %2%e%-1"
    ...(0)> run(pattern, ["alpha beta gamma", "a b c"])
    ["alpha beta gamma betagamma", "a b c bc"] 
   
  
  ## Advanced Patterns 

  """

  @spec run(binary(), Enumerable.t()) :: binaries() 
  def run(pattern, input) do
    compiled = Compiler.compile!(pattern)
    []
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
