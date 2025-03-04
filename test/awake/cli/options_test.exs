defmodule Test.Awake.Cli.OptionsTest do
  use Support.CliTestCase
  alias Awake.Cli.Options
  @moduledoc false

  describe "simple case" do
    test "just a pattern" do
      assert make("pattern") == options(pattern: "pattern") 
    end
    test "just from file" do
      file = fixture("pattern_file")
      assert make(nil, file: file) == options(file: file) 
    end
    test "with input" do
      input = fixture("input_file")
      assert make("pattern", input: input) == options(pattern: "pattern", input: input)
    end
    test "input must exist" do
      input = "does not exist"
      message =
        "the file does not exist, specified via the  -i|--input option does not exist"
      assert_cli_error(message, fn ->
        make("pattern", input: input)
      end)
    end
    test "but output must not exist" do
      file = fixture("pattern_file")
      input = fixture("input_file")
      output = "such a future file"

      assert make(
        nil, 
        input: input,
        output: output,
        file: file
      ) == options(pattern: nil, file: file, input: input, output: output)
    end
    test "but not both" do
      message =
        "pattern is not allowed with the --file <file> option, as it is read from <file>"
      assert_cli_error(message, fn ->
        make("pattern", file: fixture("pattern_file"))
      end)
    end
    test "no args is not good enough" do
      message =
        "a pattern is needed, provide it either via a CL argument or the -f|--file or the -b|--byte-code option"
      assert_cli_error(message, fn ->
        make(nil)
      end)
    end
  end

  describe "compiling" do
    test "compiling a pattern" do
      assert make("pattern", compile: true) == options(compile: true, pattern: "pattern") 
    end
    test "compiling from a file" do
      file = fixture("pattern_file")
      assert make(nil, compile: true, file: file) == options(compile: true, pattern: nil, file: file) 
    end
    test "compiling with file <-> pattern conflict" do
      message =
        "pattern is not allowed with the --file <file> option, as it is read from <file>"
      assert_cli_error(message, fn ->
        make("pattern", compile: true, file: fixture("pattern_file"))
      end)
    end
    test "compiling wiht input not allowed" do
      message =
        "neither the option --parse, --input or --emit is allowed with the --compile option"
      assert_cli_error(message, fn ->
        make("pattern", compile: true, input: fixture("input_file"))
      end)
    end
  end

  describe "parsing" do
    test "parsing a pattern" do
      assert make("pattern", parse: true) == options(parse: true, pattern: "pattern") 
    end
    test "parsing from a file" do
      file = fixture("pattern_file")
      assert make(nil, parse: true, file: file) == options(parse: true, pattern: nil, file: file) 
    end
    test "parsing with file <-> pattern conflict" do
      message =
        "pattern is not allowed with the --file <file> option, as it is read from <file>"
      assert_cli_error(message, fn ->
        make("pattern", parse: true, file: fixture("pattern_file"))
      end)
    end
    test "parsing wiht input not allowed" do
      message =
        "the option --input is not allowed with the --parse option"
      assert_cli_error(message, fn ->
        make(nil, file: fixture("pattern_file"), parse: true, input: fixture("input_file"))
      end)
    end
  end

  describe "emitting" do
    test "emitting a pattern" do
      assert make("pattern", emit: true) == options(emit: true, pattern: "pattern") 
    end
    test "emitting from a file" do
      file = fixture("pattern_file")
      assert make(nil, emit: true, file: file) == options(emit: true, pattern: nil, file: file) 
    end
    test "emitting with file <-> pattern conflict" do
      message =
        "pattern is not allowed with the --file <file> option, as it is read from <file>"
      assert_cli_error(message, fn ->
        make("pattern", emit: true, file: fixture("pattern_file"))
      end)
    end
    test "emit with input" do
      message =
        "neither the option --parse nor --input is not allowed with the --emit option"
      assert_cli_error(message, fn ->
        make("pattern", emit: true, input: fixture("input_file"))
      end)
    end
    test "emit without a pattern" do
      message =
        "a pattern is needed, provide it either via a CL argument or the -f|--file or the -b|--byte-code option"
      assert_cli_error(message, fn ->
        make(nil, emit: true, output: "hello")
      end)
    end
  end

  describe "byte_code" do
    test "with a file" do
      byte_code = fixture("byte_code")
      assert make("pattern", byte_code: byte_code) == options(pattern: "pattern", byte_code: byte_code) 
    end
    test "need a pattern file" do
      byte_code = "does not exist"
      message =
        "the file does not exist, specified via the -b|--byte_code option does not exist"
      assert_cli_error(message, fn ->
        make(nil, byte_code: byte_code, output: "hello")
      end)
    end
  end

  defp make(pattern, kwds \\ []), do: Options.from_kwds(kwds, pattern)
  defp options(kwds), do: struct(Options, kwds)


end
# SPDX-License-Identifier: AGPL-3.0-or-later
