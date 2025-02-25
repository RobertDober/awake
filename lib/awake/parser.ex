defmodule Awake.Parser do
  use Awake.Types

  import __MODULE__.RgxParser
  alias Awake.Exceptions.SyntaxError

  @moduledoc ~S"""
  Parse a pattern into an AST
  """

  @doc ~S"""
  Parses the pattern

  ### Verbatim chunks

  If we want to print a fixed text for each line of input from stdin, we can use
  a verbatim pattern

  iex(1)> parse("hello world")
  [{:verb, "hello world"}]

  but need to escape `%`

  iex(2)> parse("%%")
  [{:verb, "%"}]

  and also "("

  iex(3)> parse("((")
    [{:verb, "("}]

  verbs are glued together

      iex(4)> parse("hello ((%%")
        [{:verb, "hello (%"}]

  ### Field chunks

  verbs are seperated by fields

          iex(5)> parse("hello %c and more%%")
          [{:verb, "hello "}, {:field, "c"}, {:verb, " and more%"}]

  fields are either predefined, or indices into fields

          iex(6)> parse("%c%tm%2%-1%t or %")
          [{:field, "c"}, {:field, "tm"}, {:field, 2}, {:field, -1}, {:field, "t"},  {:verb, " or "}, {:field, 0}]

  ### Ambigous patterns

  Assumeing we want to parse the input into `[{:field, 0}, {:field, 0}]`
  but, `"%%"` would be parsed into `[{:verb, "%"}]`.

  And we want to parse the input into `[{:field, "t"}, {:verb, "s"}]` but `"%ts"` would be parsed into `[{:field, "ts"}]`

  How can we fix this?

  Enter the empty function, "`()`"

  **N.B.** that we can get `[{:verb, "()"}]` easily enough from
  the input `"(()"` and also that it is not part of the ast.

          iex(7)> parse("%()%")
          [{:field, 0}, {:field, 0}]

          iex(8)> parse("%t()s")
          [{:field, "t"}, {:verb, "s"}]

  ### Function Pipelines

  The syntax of function pipelines is simply a list of s-expressions, however
  the preceding field is integrated into the function ast tuple

  iex(9)> parse("%(+ 1 2)(tos 16) %c(lpad 5 0)")
  [{:pipe, 0,  [[:+, 1, 2],  [:tos, 16]]}, {:verb, " "}, {:pipe, "c",  [[:lpad, 5, 0]]}]

  N.B. that inside a function `%` is just `%`

  iex(10)> parse("%(% 2)")
  [{:pipe, 0,  [[:%, 2]]}]

  """

  @spec parse(binary()) :: ast_t()
  def parse(pattern) do
    case parse_pattern(pattern) do
      {"", ast} -> ast
      {rest, _} -> raise SyntaxError, "unexpected input #{rest}"
    end
  end

  @spec parse_pattern(binary(), ast_t()) :: parse_result(ast_t())
  def parse_pattern(pattern, ast \\ [])
  def parse_pattern("", ast) do
    {"", Enum.reverse(ast)}
  end
  def parse_pattern("%%" <> rest, ast) do
    {rest1, verb} = parse_verb(rest, "%") # |> IO.inspect() 
    parse_pattern(rest1, [{:verb, verb}|ast])
  end
  def parse_pattern("((" <> rest, ast) do
    {rest1, verb} = parse_verb(rest, "(")
    parse_pattern(rest1, [{:verb, verb}|ast])
  end
  def parse_pattern("%" <> rest, ast) do
    {rest1, field} = parse_field(rest)
    # IO.inspect(rest1, label: :rest1)
    parse_pattern(rest1, [field|ast])
  end
  def parse_pattern("(" <> rest, ast) do
    {rest1, s_exp} = parse_s_exp(rest)
    parse_pattern(rest1, [{:s_exp, s_exp}|ast])
  end
  def parse_pattern(input, ast) do
    {rest, verb} = parse_verb(input)
    parse_pattern(rest, [{:verb, verb}|ast])
  end

  @spec maybe_parse_atom(binary()) :: parse_result?(atom())
  defp maybe_parse_atom(input) do
    case parse_rgx(input, ~r/ \A [[:alnum:][:graph:]]+ (\s?) (.*) /x) do
      nil -> nil
      {atom, rest} -> {rest, String.to_atom(atom)}
    end
  end

  @spec maybe_parse_field(binary()) :: parse_result?(field_t())
  defp maybe_parse_field(input)
  defp maybe_parse_field("%" <> rest) do
    parse_field(rest)
  end
  defp maybe_parse_field(_), do: nil

  @spec maybe_parse_int(binary()) :: parse_result?(integer())
  defp maybe_parse_int(input) do
    case parse_rgx(input, ~r/ \A ( [-+]? \d+ ) (\s?) (.*) /x) do
      nil -> nil
      {number, rest} -> {rest, String.to_integer(number)}
    end
  end

  @spec maybe_parse_s_exp(binary()) :: parse_result?(ast_t())
  defp maybe_parse_s_exp(input)
  defp maybe_parse_s_exp("(" <> rest) do
    parse_s_exp(rest)
  end
  defp maybe_parse_s_exp(_), do: nil

  @spec maybe_parse_string(binary()) :: parse_result?(binary())
  defp maybe_parse_string(input)
  defp maybe_parse_string("'"<>rest) do
    parse_string("'", rest)
  end
  defp maybe_parse_string(~s{"}<>rest) do
    parse_string(~s{"}, rest)
  end
  defp maybe_parse_string(_), do: nil

  @spec parse_field(binary()) :: parse_result(field_t()) 
  defp parse_field(input)
  defp parse_field("") do
    {"", {:field, 0}}
  end
  defp parse_field(" "<>rest) do
    {rest, {:field, 0}}
  end
  defp parse_field(input) do
    case maybe_parse_int(input) do
      nil -> parse_field_name(input)
      {rest, int} -> {rest, {:field, int}}
    end
  end

  @spec parse_field_name(binary()) :: parse_result(field_t())
  defp parse_field_name(input) do
    case parse_rgx(input, ~r/ \A ( [-_\w!?]+ ) (\s)? (.*) /x) do
      {name, rest} -> {rest, {:field, String.to_atom(name)}}
      nil -> {input, {:field, 0}}
    end
  end

  @spec parse_s_exp(binary(), list()) ::  parse_result(ast_t())
  defp parse_s_exp(input, ast \\ [])
  defp parse_s_exp(")" <> rest, ast) do
    {rest, Enum.reverse(ast)}
  end
  defp parse_s_exp(input, ast) do
    case parse_s_exp_entry(input) do
      {rest, entry} -> parse_s_exp(rest, [entry|ast])
      # message -> raise SyntaxError, "unexpected #{message} in s_expression"
    end
  end

  @spec parse_s_exp_entry(binary()) :: parse_result(ast_t())
  defp parse_s_exp_entry(input) do
    cond do
      result = maybe_parse_int(input) -> result
      result = maybe_parse_field(input) -> result
      result = maybe_parse_string(input) -> result
      result = maybe_parse_atom(input) -> result
      result = maybe_parse_s_exp(input) -> result
      true -> raise SyntaxError, "unexpected s_exp_entry #{input}"
    end
  end

  @spec parse_string(binary(), binary(), IO.chardata()) :: parse_result?(binary())
  def parse_string(delim, input, ast \\ []) do
    case input do
      << ^delim :: binary-size(1), ^delim :: binary-size(1), rest :: binary>> -> parse_string(delim, rest, [ast, delim])
      << ^delim :: binary-size(1), rest :: binary>> -> {rest, IO.chardata_to_string(ast)}
      << head :: utf8, rest :: binary >> -> parse_string(delim, rest, [ast, [head]])
    end
  end

  @spec parse_verb(binary(), IO.chardata) :: parse_result(binary())
  defp parse_verb(input, result \\ [])
  defp parse_verb("%%" <> rest, result) do
    parse_verb(rest, [result, "%"])
  end
  defp parse_verb("((" <> rest, result) do
    parse_verb(rest, [result, "("])
  end
  defp parse_verb("%" <> rest, result) do
    { "%" <> rest, result |> IO.chardata_to_string }
  end
  defp parse_verb("(" <> rest, result) do
    { "(" <> rest, result |> IO.chardata_to_string }
  end
  defp parse_verb(<< head::utf8, tail::binary >>, result) do
    parse_verb(tail, [result, head])
  end
  defp parse_verb("", result) do
    { "", result |> IO.chardata_to_string }
  end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
