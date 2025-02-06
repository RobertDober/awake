dnefmodule Awake.Primitives.Function do
  use Awake.Types
  @moduledoc ~S"""
  Function wrapper around predefined functions
  """

  defstruct name: nil, fun: nil, needs: 2, allows: 0, pulls: 0

  @type t :: %__MODULE__{name: atom(), fun: (... -> any()), needs: non_neg_integer(), allows: non_neg_integer(), pulls: non_neg_integer()}

  @spec new((...-> any()), Keyword.t()) :: t()
  def new(fun, opts \\ []) do
    %__MODULE__{
      name: Keyword.fetch!(opts, :name),
      fun: fun,
      allows: Keyword.get(opts, :allows, 2),
      needs: Keyword.get(opts, :needs, 2),
      pulls: Keyword.get(opts, :pulls, 1)
    }
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
