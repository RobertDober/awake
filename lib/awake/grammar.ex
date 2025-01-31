defmodule Awake.Grammar do
  use Awake.Types
  import Minipeg.{Combinators, Mappers, Parsers}
  @moduledoc false

  def pattern do
    many(verb_parser(), "pattern parser")
    # many(select([
    #   verb_parser(),
    # ]), "pattern parser")
  end


  defp double_escape_parsers(escapees) do
      escapees
      |> String.graphemes
      |> Enum.map(
        &literal_parser(&1 <> &1) |> map(fn _ -> {:verb, &1} end)
      )
  end

  defp verb_parser do
    select([
      verb_string_parser(),
    ] ++
      double_escape_parsers("(%"))
  end
  # [
      # literal_parser("%%") |> map(fn _ -> {:verb, "%"} end),
      # literal_parser("((") |> map(fn _ -> {:verb, "("} end),
      # ])
    # parsers = [
    #   verb_string_parser()
    # ] ++ double_escape_parser("%(")
    # select(parsers, "verb parser")

    defp verb_string_parser do
      many(not_char_parser("%("), nil, 1)
      |> map(&{:verb, IO.chardata_to_string(&1)})
    end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
