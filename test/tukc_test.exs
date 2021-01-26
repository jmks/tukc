defmodule TukcTest do
  use ExUnit.Case
  doctest Tukc

  test "greets the world" do
    assert Tukc.hello() == :world
  end
end
