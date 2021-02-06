defmodule Tukc.App.SelectionListTest do
  use ExUnit.Case, async: true

  import Tukc.App.SelectionList

  describe "next" do
    test "returns the next item" do
      list = new([1, 2, 3])

      assert selected(list) == 1
      assert selected(list |> next) == 2
      assert selected(list |> next |> next) == 3
      assert selected(list |> next |> next |> next) == 1
    end
  end

  describe "prev" do
    test "returns the previous item" do
      list = new([1, 2, 3]) |> next |> next

      assert selected(list) == 3
      assert selected(list |> prev) == 2
      assert selected(list |> prev |> prev) == 1
      assert selected(list |> prev |> prev |> prev) == 3
    end
  end
end
