defmodule Tukc.App.Selection do
  def next(collection, index) do
    new_index = rem(index + 1, length(collection))
    new_selected = Enum.at(collection, new_index)

    {new_selected, new_index}
  end

  def previous(collection, index) do
    new_index = if index == 0, do: length(collection) - 1, else: index - 1
    new_selected = Enum.at(collection, new_index)

    {new_selected, new_index}
  end
end
