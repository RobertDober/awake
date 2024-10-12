defmodule Awake.Types do

  defmacro __using__(_opts \\ []) do
    quote do
      @type ast_entry_t :: binary() | field_t() | pipeline_t()
      @type ast_t :: list(ast_entry_t)

      @type binaries :: list(binary())

      @type field_t :: atom()

      @type pipeline_entry_t :: {atom(), list()}
      @type pipeline_t :: list(pipeline_entry_t())

      @type result_t(t) :: {:ok, t}, {:error, binary()}
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
