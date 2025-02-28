defmodule Awake.Builtin do
  use Awake.Types
  alias Awake.Exceptions.CompilationError

  @moduledoc ~S"""
  A wrapper around builtin functions, from the Builtin module
  """

  defstruct name: nil, arity: nil, function: nil

  @type t :: %__MODULE__{name: atom(), arity: maybe(non_neg_integer()), function: function()}

  @builtins %{
  +: &Builtins._add/1,
  }

  @spec make(atom(), non_neg_integer()) :: t()
  def make(name, arity) do
    case Map.fetch(@builtins, name) do
      {:ok, {function, arity}} -> %__MODULE__{function: function, name: name, arity: arity}
      {:ok, function} -> %__MODULE__{function: function, name: name}
      :error -> raise CompilationError, "no builtin with name: #{name}/#{arity}"
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
