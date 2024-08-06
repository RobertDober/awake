defmodule EwokTest do
  use ExUnit.Case
  doctest Ewok

  test "greets the world" do
    assert Ewok.hello() == :world
  end
end
