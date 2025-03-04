defmodule Awake.Cli.Options do
  use Awake.Types
  alias Awake.Exceptions.CliError

  @moduledoc ~S"""
  Representattion of options and arguments of the CLI
  """

  defstruct pattern: nil, 
    byte_code: nil,
    compile: false,
    emit: false,
    file: nil,
    input: nil,
    output: nil,
    parse: false

  @type t :: %__MODULE__{
    pattern: binary?(), 
    byte_code: binary?(),
    compile: boolean(),
    emit: boolean(),
    file: binary?(),
    input: binary?(),
    output: binary?(),
    parse: boolean(),
  }

  @spec from_kwds(Keyword.t, binary?()) :: t()
  def from_kwds(options, pattern \\ nil) do
    struct!(
      __MODULE__,
      options |> Keyword.put(:pattern, pattern)
    )
    |> check!()
  end

  @spec check!(t()) :: t()
  defp check!(%__MODULE__{}=options) do
    options
    |> check_byte_code!()
    |> check_compile!()
    |> check_parse!()
    |> check_emit!()
    |> check_file!()
    |> check_input!()
    |> check_present!()
  end

  @spec check_byte_code!(t()) :: t()
  defp check_byte_code!(options)
  defp check_byte_code!(%__MODULE__{byte_code: nil}=options), do: options
  defp check_byte_code!(%__MODULE__{byte_code: byte_code}=options) do
    if options.parse ||
      options.compile ||
        options.emit do 
      raise CliError, "neither --parse, --compile, or --emit are allowed with the --byte-code option"
    else
      if File.exists?(byte_code) do
      options
      else
        raise CliError, "the file #{byte_code}, specified via the -b|--byte_code option does not exist"
      end
    end
  end
  defp check_byte_code!(options), do: options

  @spec check_compile!(t()) :: t()
  defp check_compile!(options)
  defp check_compile!(%__MODULE__{compile: true}=options) do
    if options.parse ||
      options.input ||
      options.emit do
      raise CliError, "neither the option --parse, --input or --emit is allowed with the --compile option"
    else
      options
    end
  end
  defp check_compile!(options), do: options

  @spec check_emit!(t()) :: t()
  defp check_emit!(options) 
  defp check_emit!(%__MODULE__{emit: true}=options) do
    if options.parse || options.input do
      raise CliError, "neither the option --parse nor --input is not allowed with the --emit option"
    else
      options
    end
  end
  defp check_emit!(options), do: options

  @spec check_file!(t()) :: t()
  defp check_file!(options) 
  defp check_file!(%__MODULE__{file: nil}=options), do: options
  defp check_file!(%__MODULE__{file: file}=options) do
    if options.pattern do
      raise CliError, "pattern is not allowed with the --file <file> option, as it is read from <file>"
    else
      if File.exists?(file) do
        options
      else
        raise CliError, "the file #{file}, specified via the  -f|--file option does not exist"
      end
    end
  end

  @spec check_input!(t()) :: t()
  defp check_input!(options) 
  defp check_input!(%__MODULE__{input: nil}=options), do: options
  defp check_input!(%__MODULE__{input: input}=options) do
    if File.exists?(input) do
      options
    else
      raise CliError, "the file #{input}, specified via the  -i|--input option does not exist"
    end
  end

  @spec check_parse!(t()) :: t()
  defp check_parse!(options)
  defp check_parse!(%__MODULE__{parse: true}=options) do
    if options.input do
      raise CliError, "the option --input is not allowed with the --parse option"
    else
      options
    end
  end
  defp check_parse!(options), do: options

  @spec check_present!(t()) :: t()
  defp check_present!(options)
  defp check_present!(%__MODULE__{}=options) do
    if options.pattern || options.file || options.byte_code do
      options
    else
      raise CliError, "a pattern is needed, provide it either via a CL argument or the -f|--file or the -b|--byte-code option"
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
