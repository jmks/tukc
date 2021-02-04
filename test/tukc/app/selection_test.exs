defmodule Tukc.App.SelectionTest do
  use ExUnit.Case, async: true

  alias Tukc.App.Selection

  describe "next" do
    test "returns the next item" do
      assert {:two, 1} == Selection.next([:one, :two], 0)
      assert {:three, 2} == Selection.next([:one, :two, :three], 1)
    end

    test "wraps around collection" do
      assert {:one, 0} == Selection.next([:one, :two, :three], 2)
    end
  end

  describe "previous" do
    test "returns the previous item" do
      assert {:two, 1} == Selection.previous([:one, :two, :three], 2)
      assert {:one, 0} == Selection.previous([:one, :two, :three], 1)
    end

    test "wraps around collection" do
      assert {:three, 2} == Selection.previous([:one, :two, :three], 0)
    end
  end
end
