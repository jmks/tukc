defmodule Tukc.App.SelectionList do
  @enforce_keys [:array, :index]
  defstruct [:array, :index]

  def new(list) do
    %__MODULE__{array: :array.from_list(list), index: 0}
  end

  def selected(sel), do: :array.get(sel.index, sel.array)

  def select(sel, selector) do
    index = Enum.find(range(sel), fn index ->
      selector.(:array.get(index, sel.array))
    end)

    if index do
      %{sel | index: index}
    else
      sel
    end
  end

  def next(sel) do
    new_index = rem(sel.index + 1, :array.size(sel.array))

    %{sel | index: new_index}
  end

  def previous(sel) do
    new_index = if sel.index == 0, do: :array.size(sel.array) - 1, else: sel.index - 1

    %{sel | index: new_index}
  end

  def replace(sel, matcher, replacement) do
    Enum.reduce(range(sel), sel, fn index, sel ->
      value = :array.get(index, sel.array)

      if matcher.(value) do
        new_value = if is_function(replacement) do
          replacement.(value)
        else
          replacement
        end
        new_array = :array.set(index, new_value, sel.array)

        %{sel | array: new_array}
      else
        sel
      end
    end)
  end

  def to_list(sel) do
    :array.to_list(sel.array)
  end

  defp range(sel) do
    upper_index = :array.size(sel.array) - 1

    0..upper_index
  end
end
