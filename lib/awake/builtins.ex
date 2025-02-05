defmodule Awake.Builtins do
  alias Awake.Exceptions.CompilationError
  alias Awake.State
  alias Awake.Builtins.Arithmetic, as: A
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

  @spec ignore(State.t) :: State.t
  defp ignore(%State{opstack: [h|t], output: output}=state) do
    State.ignore(state)
  end

  @spec duplicate(State.t) :: State.t
  defp duplicate(%State{opstack: [h|_], output: output}=state) do
    %{state|output: [h|output]}
  end

  @spec builtin_functions() :: map()
  defp builtin_functions do
    %{
      +: %{needs: 2, allows: 2, pulls: 0, fun: &A.aplus/1},
      -: %{needs: 2, allows: 2, pulls: 0, fun: &A.aminus/1},
      *: %{needs: 2, allows: 2, pulls: 0, fun: &A.amult/1},
      /: %{needs: 2, allows: 2, pulls: 0, fun: &A.adiv/1},
      %: %{needs: 2, allows: 2, pulls: 0, fun: &A.amod/1},
      d: %{needs: 0, allows: 0, pulls: 0, fun: &duplicate/1}, # all these zeroes indicate that this is a state function
      i: %{needs: 0, allows: 0, pulls: 0, fun: &ignore/1}, # all these zeroes indicate that this is a state function
      lpad: %{needs: 2, allows: 3, pulls: 1, fun: &S.lpad/1},
      rpad: %{needs: 2, allows: 3, pulls: 1, fun: &S.rpad/1},
    }
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
