defmodule Awake.Builtins.Strings do
  @moduledoc false

  @spec lpad(list()) :: binary()
  def lpad([subject, size|args]) do
    apply(String, :pad_leading, [to_string(subject), size | Enum.map(args, &to_string/1)])
  end

  @spec rpad(list()) :: binary()
  def rpad([subject, size|args]) do
    apply(String, :pad_trailing, [to_string(subject), size | Enum.map(args, &to_string/1)])
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
