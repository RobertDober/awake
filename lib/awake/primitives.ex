defmodule Awake.Primitives do
  use Awake.Types
  alias Awake.Primitives.{Function, Functions}

  @moduledoc ~S"""
    Primitive operations like lnb and so forth
  """

  @primitive_field_names [
    ctm: "ctm",
    ct:  "cts",
    cxm: "cxm",
    cx:  "cxs",
    tm:  "stm",
    t:   "sts",
    xm:  "sxm",
    x:   "sxs",
    c:   "lnb"
  ]

  @primitive_functions [
    +: Function.new(&Function.aplus/2, name: :+), 
  ]

  @spec defined_field_names() :: binaries()
  def defined_field_names do
    @primitive_field_names
    |> Keyword.keys
    |> Enum.map(&to_string/1)
  end

  @spec get_field_name(atom()|binary()) :: binary?()
  def get_field_name(name)
  def get_field_name(name) when is_binary(name) do
    @primitive_field_names
    |> Keyword.get(String.to_atom(name)) 
  end
  def get_field_name(name) do
    @primitive_field_names
    |> Keyword.get(name) 
  end

  @spec get_function(atom()) :: Function.t
  def get_function(name) do
    @primitive_functions
    |> Keyword.get(name) 
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
