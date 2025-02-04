defmodule Awake.Builtins do
  alias Awake.Exceptions.CompilationError
  alias Awake.State
  alias Awake.Builtins.Arithmetic, as: A
  alias Awake.Builtins.Functions, as: F
  alias Awake.Builtins.Strings, as: S

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

  @spec builtin_functions() :: map()
  defp builtin_functions do
    %{
      +: &A.aplus/1,
      -: &A.aminus/1,
      *: &A.amult/1,
      /: &A.adiv/1,
      %: &A.amod/1,
      d: &duplicate/1,
      lpad: &S.lpad/1,
      rpad: &S.rpad/1,
    }
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
