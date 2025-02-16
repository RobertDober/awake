defmodule Awake.Exceptions do
  @moduledoc ~S"""
  Defines all exceptions used in this library
  """

  defmodule CompilationError do
    defexception [:message]

    @impl true
    def exception(value) do
      %__MODULE__{message: value}
    end
  end

  defmodule RuntimeError do
    defexception [:message]

    @impl true
    def exception(value) do
      %__MODULE__{message: value}
    end
  end

  defmodule SyntaxError do
    defexception [:message]

    @impl true
    def exception(value) do
      %__MODULE__{message: value}
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
