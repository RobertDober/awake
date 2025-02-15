defmodule Awake.Primitives.Function do
  use Awake.Types
  @moduledoc ~S"""
   Function wrapper around predefined functions
  """

  defstruct name: nil, fun: nil, needs: 2, defaults: [], pulls: 0

  @type t :: %__MODULE__{name: atom(), fun: function(), needs: non_neg_integer(), defaults: list(), pulls: non_neg_integer()}

  @spec new(function(), Keyword.t()) :: t()
  def new(fun, opts \\ []) do
    %__MODULE__{
      name: Keyword.fetch!(opts, :name),
      fun: fun,
      defaults: Keyword.get(opts, :defaults, []),
      needs: Keyword.get(opts, :needs, 2),
      pulls: Keyword.get(opts, :pulls, 1)
    } 
  end

  @spec field(function(), name_t()) :: t()
  def field(fun, name) do
    %__MODULE__{
      name: name,
      fun: fun,
      needs: 0
    }
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
