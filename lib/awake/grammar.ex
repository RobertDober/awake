defmodule Awake.Grammar do
  use Awake.Types
  import Minipeg.{Combinators, Mappers, Parsers}
  @moduledoc false

  @typep t :: Minipeg.Parser.t()
  @spec pattern() :: t()
  def pattern do
    sequence([
      many(select([
        verbs_parser(),
        field_parser()
      ]),
        "pattern parser",
        1),
      end_parser()])
      |> map(&List.first/1) 
  end

  @spec double_escape_parsers(binary()) :: list(t())
  defp double_escape_parsers(escapees) do
    escapees
    |> String.graphemes
    |> Enum.map(
      &literal_parser(&1 <> &1) |> map(fn _ -> {:verb, &1} end)
    )
  end


  @defined_fieldnames ~W[c now tms ts xs xms]
  @spec field_name_parser() :: t()
  defp field_name_parser do
    @defined_fieldnames
    |> Enum.map(&literal_parser(&1)) 
    |> select()
  end

  @spec field_parser() :: t()
  defp field_parser do
    sequence([
      literal_parser("%"),
      maybe(select([
        field_name_parser(),
        int_parser()
      ]))
    ])
    |> map(&make_field/1) 
  end

  @spec join_verb_asts(list(verb_t())) :: verb_t()
  defp join_verb_asts(asts) do
    {
      :verb,
      asts
      |> Enum.map(fn {:verb, content} -> content end) 
      |> Enum.join 
    }
  end

  @spec make_field(binaries()) :: field_t()
  defp make_field(["%", name]) do
    {:field, name || 0}
  end

  @spec verbs_parser() :: t()
  defp verbs_parser do
    many(verb_parser(), "verbs parser", 1)
    |> map(&join_verb_asts/1)
    # |> debug()
  end

  @spec verb_parser() :: t()
  defp verb_parser do
    select([
      verb_string_parser(),
    ] ++
      double_escape_parsers("(%"))
  end

  @spec verb_string_parser() :: t()
  defp verb_string_parser do
    many(not_char_parser("%("), nil, 1)
    |> map(&{:verb, IO.chardata_to_string(&1)})
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
