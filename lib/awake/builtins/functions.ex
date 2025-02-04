defmodule Awake.Builtins.Functions do
  use Awake.Types
  alias Awake.State

  @moduledoc ~S"""
  An abstraction over functions operating on the state
  """

  defstruct fun: nil, name: ""

  @type t :: %__MODULE__{fun: State.fun_t, name: binary()}

end
# SPDX-License-Identifier: AGPL-3.0-or-later
