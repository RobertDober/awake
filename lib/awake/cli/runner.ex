defmodule Awake.Cli.Runner do
  use Awake.Types
  alias Awake.Cli.Options
  alias Awake.{Compiler, Parser, Runtime}

  @moduledoc ~S"""
  Implement all CLI actions other then help and version

  """

  @spec compile(binary(), (binary()) :: :ok) :: :ok
  def compile(pattern, writer) do
    pattern
    |> Compiler.compile(true)
    |> Enum.each(fn chunk ->
      writer.(inspect(chunk))
    end)
  end

  @spec parse(binary(), (binary()) :: :ok) :: :ok
  def parse(pattern, writer) do
    pattern
    |> Parser.parse
    |> Enum.each(fn chunk ->
      writer.(inspect(chunk))
    end)
  end

  @spec run(Options.t) :: :ok
  def run(options)
  def run(%Options{parse: true, output: output, file: file, pattern: pattern}=options) do
    parse(pattern || File.read!(file), line_writer(make_output_device(output)))
  end
  def run(%Options{compile: true, output: output, file: file, pattern: pattern}=options) do
    compile(pattern || File.read!(file), line_writer(make_output_device(output)))
  end
  def run(%Options{emit: true, output: output, file: file, pattern: pattern}=options) do
    raise Awake.Exceptions.CliError, "pattern to byte-code compilation (-e|--emit) not yet implemented"
  end
  def run(%Options{byte_code: nil, output: output, file: file, input: input, pattern: pattern}=options) do
    compiled = Compiler.compile(pattern || File.read!(file), false)
    stream = make_input_stream(input) |> Stream.map(&String.trim_trailing/1)
    output_fn = line_writer(make_output_device(output))
    Runtime.run_on_input(stream, compiled, output_fn)
  end
  def run(%Options{byte_code: byte_code, output: output, input: input}=options) do
    raise Awake.Exceptions.CliError, "byte-code compilation (-b|--byte-code) not yet implemented"
  end

  defp line_writer(device) do
    fn data ->
      IO.write(device, data)
      IO.write(device, "\n")
    end
  end

  defp make_input_stream(input)
  defp make_input_stream(nil), do: IO.stream(:stdio, :line)
  defp make_input_stream(filename) when is_binary(filename) do
    IO.stream(File.open!(filename), :line)
  end
  defp make_input_stream(list), do: list

  defp make_output_device(output)
  defp make_output_device(nil), do: :stdio
  defp make_output_device(output) do
    File.open!(output, [:write])
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
