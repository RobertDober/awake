# Awake


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `awake` to your list of dependencies in `mix.exs`:

```elixir
def deps do
[
    # ...
    {:awake, "~> 0.1.0"},
    # ...
]
end
```

## Synopsis

An _awk_ like 'mini language', with a more concise syntax (tailored for command line usage)
and a little bit less powerful (for now).

_Awake_ applies a pattern to each input line.

The pattern is composed by a sequence of  _verbatim text_, _field_definitions_ and 
_function_pipelines_.

If not inhibited by any function in a _function_pipeline_ a default print of the pattern is
the action at the end of the pattern's application to a line.

### Simple Patterns: Fields

All Fields start with a `%` (use `%%` for a verbatim `%` in the pattern) and have an 
optional name. It ends with a white space or the `%e` (`end_of_pipeline`, or `epsilon) field which
is rendered as an empty string and can also interrupt a pipeline.

### Complex Patterns: Function Pipelines (aka _pipelines_)

If a fieled is followed by a list of lisp s-expressions the whole together forms a _pipeline_.
As indicated by the name this will be interpreted as a pipeline of functions with the field value
injected into it.

### Simple Patterns: Verbatim text

All text not containing a `%` or a `(` is verbatim text, and as mentioned above `%%` and `((` will
be parsed as verbatim text containung `%` and `(` respectively.


## Implementation

This is implemented with a 3 phase compilation

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

For a detailed description refer to the [doctests of the Parser](lib/awake/parser.ex)





Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/awake>.

# Author

Copyright © 2025 Robert Dober robert <dot>
                    DOBER <at> GmaIL <dot> com

# LICENSE

GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 or later. Please refer to [LICENSE](LICENSE) for details.
<!--SPDX-License-Identifier: AGPL-3.0-or-later-->
