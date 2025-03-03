defmodule Support.CliTestCase do

  defmacro __using__(_opts \\ []) do
    quote do
      use ExUnit.Case

      def fixture(file), do: Path.join("test/fixtures", file)

      def assert_cli_error(message, fun) do
        assert_raise(Awake.Exceptions.CliError, message, fun)
    end
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
