defmodule Awake.Primitives do
  use Awake.Types
  alias Awake.Primitives.{Function, Functions}

  @moduledoc ~S"""
    Primitive operations like lnb and so forth
  """

  @primitive_field_names [
    ctm: :ctm,
    ct:  :cts,
    cxm: :cxm,
    cx:  :cxs,
    tm:  :stm,
    t:   :sts,
    xm:  :sxm,
    x:   :sxs,
    c:   :lnb
  ]

  @primitive_functions [
    +: Function.new(&Functions.aplus/2, name: :+), 
    *: Function.new(&Functions.amult/2, name: :*), 
    -: Function.new(&Functions.aminus/2, name: :-), 
    /: Function.new(&Functions.adiv/2, name: :/), 
    %: Function.new(&Functions.amod/2, name: :%), 
    d: Function.new(&Functions.duplicate/1, name: :duplicate, needs: 0, pulls: 0),
    i: Function.new(&Functions.duplicate/1, name: :ignor , needs: 0, pulls: 0),
    lpad: Function.new(&Functions.lpad/3, name: :lpad, needs: 3, defaults: [" "], pulls: 1),
    rpad: Function.new(&Functions.rpad/3, name: :rpad, needs: 3, defaults: [" "], pulls: 1),
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

  @spec get_function(atom()) :: maybe(Function.t)
  def get_function(name) do
    @primitive_functions
    |> Keyword.get(name) 
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
