defmodule Awake.Cli do
  import ExAequo.Color, only: [putc: 2]
  alias Awake.Cli.{Options, Runner}

  @moduledoc ~S"""
  The Command Line awake
  """

  def main(argv) do
    argv
    |> parse_args()
    |> run()
  end

  defp error(message)
  defp error(message) when is_binary(message) do 
    putc([:yellow, message], :stderr)
  end
  defp error(message) do
    putc([:yellow | message], :stderr)
  end

  defp format_errors(errors, result \\ [])
  defp format_errors([], result) do
    result
    |> Enum.reverse
    |> Enum.join(", ")
  end
  defp format_errors([{option, value}|rest], result) do
    format_errors(rest, ["illegal option #{option} (#{value})"])
  end

  @switches [
    byte_code: :string,
    compile: :boolean,
    emit: :boolean,
    file: :string,
    help: :boolean,
    input: :string,
    output: :string,
    parse: :boolean,
    version: :boolean,
  ]

  @aliases [
    b: :byte_code,
    c: :compile,
    e: :emit,
    f: :file,
    h: :help,
    i: :input,
    o: :output,
    p: :parse,
    v: :version,
  ]

  defp parse_args(argv) do
    case OptionParser.parse(argv, strict: @switches, aliases: @aliases) do
      {_, _, [_ | _] = errors} -> {:error, format_errors(errors)}
      {_, [_ , _| _s], _} -> {:error, "only 0 or 1 positional arguments allowed"}
      {[{:help, true}], _, _} -> :help
      {[{:version, true}], _, _} -> :version
      {options, args, _}    -> Options.from_kwds(options, List.first(args))
    end
  end

  defp run(parsed_args)
  defp run(%Options{}=options), do: Runner.run(options)
  defp run(:version), do: version()
  defp run(:help), do: __MODULE__.Help.help

  defp version do
    with {:ok, version} <- :application.get_key(:awake, :vsn),
         do: putc([:green, "awake: v#{to_string(version)}"], :stdio)
    end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
