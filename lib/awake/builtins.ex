defmodule Awake.Builtins do
  alias Awake.Exceptions.CompilationError
  alias Awake.State

  @moduledoc ~S"""
  Implement builtin functions
  """

  @spec fetch(atom()) :: function()
  def fetch(id) do
    case Map.fetch(builtin_functions(), id) do
      {:ok, fun} -> fun
      _ -> raise CompilationError, "the function :#{id} is not defined"
    end
  end

  defp lpad([subject|args]) do
    apply(String, :pad_leading, [to_string(subject)|args])
  end

  @spec builtin_functions() :: map()
  defp builtin_functions do
    %{
      lpad: &lpad/1,
    }
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
