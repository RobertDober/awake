defmodule Support.IntegrationTestCase do
  @moduledoc false

  defmacro __using__(_opts \\ []) do
    quote do
      use ExUnit.Case
      import ExUnit.CaptureIO
      import Awake.Cli.Runner, only: [run: 1]
      import Support.RunInterface

      def lines(eles), do: "#{Enum.join(eles, "\n")}\n"
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
