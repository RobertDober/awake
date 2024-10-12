defmodule Awake.Compiler.Mappers do
  use Awake.Types

  @spec mk_field(map(), list()) :: tuple()
  def mk_field(predefined, ast)
  def mk_field(_, ["%", nil]), do: {:%, 0}
  def mk_field(_, ["%", n]) when is_number(n), do: {:%, n}
  def mk_field(predefined, ["%", name]), do: Map.get(predefined, name)

end
# SPDX-License-Identifier: AGPL-3.0-or-later
