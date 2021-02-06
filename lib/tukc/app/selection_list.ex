defmodule Tukc.App.SelectionList do
  @enforce_keys [:array, :index]
  defstruct [:array, :index]

  def new(list) do
    %__MODULE__{array: :array.from_list(list), index: 0}
  end

  def selected(sel), do: :array.get(sel.index, sel.array)

  def next(sel) do
    new_index = rem(sel.index + 1, :array.size(sel.array))

    %{sel | index: new_index}
  end

  def previous(sel) do
    new_index = if sel.index == 0, do: :array.size(sel.array) - 1, else: sel.index - 1

    %{sel | index: new_index}
  end

  def to_list(sel) do
    upper_index = :array.size(sel.array) - 1

    for x <- 0..upper_index, do: :array.get(x, sel.array)
  end
end
