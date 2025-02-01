defmodule Awake.MixProject do
  use Mix.Project

  @project "Awake"
  @version "0.1.0"
  @release_date "2025-01-30"

  @url "https://github.com/robertdober/awake"

  def project do
    [
      aliases: [docs: &build_docs/1],
      app: :ewok,
      deps: deps(),
      description: "Map lines with a powerful mini language",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      escript: escript_config(),
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>",
      ],
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod,
      version: @version,
    ]
  end

  defp escript_config do
    [main_module: Awake.Cli]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md"
      ],
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>",
      ],
      licenses: [
        "AGPL-3.0-or-later"
      ],
      links: %{
        "Github" => @url
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [release_date: @release_date],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18.5", only: [:test]},
      {:minipeg, "~> 0.7.1"},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  @prerequisites """
  run `mix escript.install hex ex_doc` and adjust `PATH` accordingly
  """
  defp build_docs(_) do
    Mix.Task.run("compile")
    ex_doc = Path.join(Mix.path_for(:escripts), "ex_doc")
    Mix.shell().info("Using escript: #{ex_doc} to build the docs")

    unless File.exists?(ex_doc) do
      raise "cannot build docs because escript for ex_doc is not installed, make sure to \n#{@prerequisites}"
    end

    args = [@project, @version, Mix.Project.compile_path()]
    opts = ~w[--main #{@project} --source-ref v#{@version} --source-url #{@url}]

    Mix.shell().info("Running: #{ex_doc} #{inspect(args ++ opts)}")
    System.cmd(ex_doc, args ++ opts)
    Mix.shell().info("Docs built successfully")
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
