defmodule Awake.Types do

  defmacro __using__(_opts \\ []) do
    quote do
      @type arity0_instruction :: :lnbtoout
      | :ctmtoout
      | :ctstoout
      | :cxmtoout
      | :cxstoout
      | :stmtoout
      | :ststoout
      | :sxmtoout
      | :sxstoout
      | :lnbtoout
      | :ctmtostk
      | :ctstostk
      | :cxmtostk
      | :cxstostk
      | :stmtostk
      | :ststostk
      | :sxmtostk
      | :sxstostk
      | :lnbtostk

      @type arity1_instruction :: :fieldout | :strtoout
      @type arity2_instruction :: :invkstk
      @type ast_entry_t :: verb_t() | field_t() | function_t()
      @type ast_t :: list(ast_entry_t)
      @type augmented_entry_t :: verb_t() | field_t() | function_t() | pipeline_t()
      @type augmented_t :: list(augmented_entry_t)

      @type binaries :: list(binary())
      @type binary? :: maybe(binary())

      @type field_t :: {:field, binary() | integer()}
      @type function_t :: {:func, list()}

      @type maybe(t) :: t | nil

      @type name_t :: binary() | atom()

      @type pipeline_t :: {:pipe, atom(), list()}

      @typep scalar :: integer() | binary() | atom()
      @typep symbolic_instruction :: 
      {arity2_instruction(), scalar(), scalar()} |
      {arity1_instruction(), scalar()} |
      {arity0_instruction}
      @type symbolic_code :: list(symbolic_instruction())

      @type verb_t :: {:verb, binary()}
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
