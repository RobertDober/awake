defmodule Awake.Parser.RgxParser do
  use Awake.Types
  @moduledoc false

  @spec parse_rgx(binary(), Regex.t) :: maybe({binary(), binary()})
  def parse_rgx(input, rgx) do
    case Regex.run(rgx, input) do
      [_, h,  t] -> {h, t}
      _ -> nil
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
