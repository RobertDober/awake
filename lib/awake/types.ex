defmodule Awake.Types do

  defmacro __using__(_opts \\ []) do
    quote do
      @type ast_entry_t :: verb_t() | field_t() | function_t()
      @type ast_t :: list(ast_entry_t)

      @type binaries :: list(binary())
      @type field_t :: {:field, binary() | integer()}
      @type function_t :: {:fun, atom(), list()}
      @type verb_t :: {:verb, binary()}
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
