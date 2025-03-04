defmodule Awake.Cli.Help do
  import ExAequo.Color, only: [putc: 2]

  @moduledoc ~S"""
  Implement -h|--help 
  """

  @help_text [
    :green, :bold, "  awake ", :reset,
    :cyan, "[options...] ",
    :magenta, "[pattern]",
    "\n", "\n", :reset,

    "  Parses, compiles a ", 
    :magenta, "pattern", :reset,
    " and then transforms each line of input according to that",
    :reset, " ",
    :magenta, "pattern",
    :reset, " ",
    "and prints the transformation to the output",
    "\n", "\n", :reset,


    "  - Input is taken from ",
    :blue, :bold, "standard input",
    :reset, " ",
    "or a file specified with the ",
    :cyan, "-i|--input", :reset, " option",
    "\n", :reset,


    "  - Output is ", :blue, :bold, "standard output",
    :reset, " ",
    "or a file specified with the ", :cyan, "-o|--output", :reset, " option",
    "\n", :reset,

    "  - ", :magenta, "Pattern", :reset,
    " is the first and only positional argument, or can be read from a file specified by the ",
    :cyan, "-f|--file ", :reset,
    "option. ", :bold, " not to be confused with the ",
    :cyan, "-i|--input", :reset, :bold,
    "\n", "\n", :reset,

    "  The options ",
    :cyan, "-c|--compile",
    :reset, " ",
    "or ",
    :cyan, "-p|--parse",
    :reset, " ",
    :magenta, " pattern", :reset,
    " can be used to debug a ",
    :magenta, "pattern",
    "\n", "\n", :reset,

    "  Patterns can also be compiled to ",
    :blue, :bold, "bytecode",
    :reset, " ",
    "by using the ", :cyan, "-e|--emit",
    :reset, " ",
    "option",
    "\n", :reset,
    "  The bytecode is not very readable, (use the ", :cyan, "-c|--compile",
    :reset, " ",
    "option to show ",
    :blue, :bold, "symbolic bytecode",
    :reset, " ",
    ")",


    "\n", "\n", :reset,
    :bold, :cyan, "Options:",
    "\n", :reset,

    :cyan, "    -e|--emit",
    :reset, " ",
    "compiles a ",
    :magenta, "pattern", :reset,
    " to ",
    :blue, :bold, "bytecode",

    "\n", :reset,
    "        can be used with:",
    :cyan, " -f|--file", :reset, " and ", :cyan, "-o|--output",
    "\n", "\n", :reset,

    :cyan, "    -p|--parse",
    :reset, " ",
    "parses a ",
    :magenta, "pattern", :reset,
    " to an ",
    :blue, :bold, "abstract syntax tree (AST)",
    "\n", :reset,
    "        can be used with:",
    :cyan, " -f|--file", :reset, " and ", :cyan, "-o|--output",
    "\n", "\n", :reset,
    
    :cyan, "    -c|--compile",
    :reset, " ", 
    "compiles a ",
    :magenta, "pattern", :reset,
    " to symbolic byte code ",
    "\n", :reset,
    "        can be used with:",
    :cyan, " -f|--file", :reset, " and ", :cyan, "-o|--output",
    "\n", "\n", :reset,
    

    :cyan, "    -b|--byte-code <file>",
    :reset, " ",
    "read and compile ",
    :blue, :bold, "bytecode",
    :reset, " ",
    "from ", :cyan, "<file>",
    :reset, " ",
    "and transform input",
    "\n", :reset,
    "        can be used with:",
    :cyan, " -i|--input", :reset, " and ", :cyan, "-o|--output",
    "\n", :reset,
    "        must not be used with:",
    :magenta, " pattern",
    :reset, " ",
    "or ",
    :cyan, "-f|--file",
    "\n", "\n", :reset,


    :cyan, "    -i|--input <file>",
    :reset, " ",
    "transform content of ", :cyan, "<file>",
    :reset, " ",
    "instead of ",
    :blue, :bold, "standard input",
    "\n", :reset,
    "        can be used with:",
    :cyan, " -b|--byte-code", :reset, " and ", :cyan, "-o|--output",
    "\n", "\n", :reset,


    :cyan, "    -f|--file <file>",
    :reset, " ",
    "reads ",
    :magenta, " pattern",
    :reset, " ",
    "from",
    :cyan, "<file>",
    :blue, :bold, "standard input",
    "\n", :reset,
    "        can be used with:",
    :cyan, " -i|--input", :reset, " and ", :cyan, "-o|--output",
    "\n", :reset,
    "        must not be used with:",
    :magenta, " pattern",
    "\n", "\n", :reset,


    :cyan, "    -o|--output <file>",
    :reset, " ",
    "writes to ", :cyan, "<file>",
    :reset, " ",
    "instead of ",
    :blue, :bold, "standard output",
    "\n", :reset,
    "        can be used with:",
    :cyan, " -i|--input ", :reset, "and ", :cyan, "-b|--byte-code", :reset, " and ", :cyan, "-f|--file",
    :reset, " ",
    :bold, "but be aware of the restrictions imposed by",
    :reset, " ",
    :cyan, "-b|--byte-code",

  ]


  def help do
    putc(@help_text, :stderr)
  end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
