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

  describe "previous" do
    test "returns the previous item" do
      list = new([1, 2, 3]) |> next |> next

      assert selected(list) == 3
      assert selected(list |> previous) == 2
      assert selected(list |> previous |> previous) == 1
      assert selected(list |> previous |> previous |> previous) == 3
    end
  end

  describe "update" do
    test "does not update non-matching elements" do
      list = new([1,2,3])

      new_list = replace(list, &(&1 > 3), nil)

      assert [1,2,3] == to_list(new_list)
    end

    test "updates the matching elements" do
      list = new([1,2,3,2])

      new_list = replace(list, &(&1 == 2), 4)

      assert [1,4,3,4] == to_list(new_list)
    end

    test "updates matching elements via function" do
      list = new([1,2,3,4])

      new_list = replace(list, &(&1 > 2), &(&1 + 1))

      assert [1,2,4,5] == to_list(new_list)
    end
  end

  describe "to_list" do
    test "returns elements from beginning" do
      list = new([1,2,3])

      assert [1,2,3] = to_list(list)
      assert [1,2,3] = to_list(list |> next)
      assert [1,2,3] = to_list(list |> previous)
    end
  end

  describe "select" do
    test "updates selected to first matching element" do
      list = new([1,2,3])

      assert 3 == select(list, fn el -> el == 3 end) |> selected
    end
  end
end
