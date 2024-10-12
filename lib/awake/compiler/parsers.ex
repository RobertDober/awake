defmodule Awake.Compiler.Parsers do
  use Awake.Types

  import Minipeg.{Combinators, Parsers}
  alias Awake.Compiler.Mappers, as: M

  @predefined_fields %{
    "e" => {:e}, 
  }

  @spec pattern_parser() :: Minipeg.Parser.t()
  def pattern_parser do
    sequence([
      many_sel([
        escaped_percent_parser(),
        verbatim_parser(),
        field_parser(),
      ]),
      end_parser()
    ])
    |> map(fn [ast, nil] -> ast end) 
  end

  @spec escaped_percent_parser() :: Minipeg.Parser.t()
  defp escaped_percent_parser do
    literal_parser("%%", "escaped_percent_parser")
    |> map(fn _ -> "%" end) 
  end

  @spec field_parser :: Minipeg.Parser.t()
  defp field_parser do
    sequence([
      char_parser("%"),
      maybe(field_name_parser()),
    ])
    |> map(&M.mk_field(@predefined_fields, &1))
  end

  @spec field_name_parser() :: Minipeg.Parser.t()
  defp field_name_parser do
    select([
      int_parser(),
      predefined_name_parser(),
    ])
  end

  @spec predefined_name_parser :: Minipeg.Parser.t()
  defp predefined_name_parser do
    ident_parser()
    |> satisfy(&Map.get(@predefined_fields, &1))
  end

  @spec verbatim_parser() :: Minipeg.Parser.t()
  defp verbatim_parser do
    rgx_match_parser("[^%]+", "verbatim_parser") 
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
