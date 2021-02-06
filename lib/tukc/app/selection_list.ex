defmodule Tukc.App.SelectionList do
  def new(list) do
    {[], list}
  end

  def selected({_, [next | _]}), do: next

  def next({prev, [last]}) do
    {[], Enum.reverse([last|prev])}
  end

  def next({prev, [next|rest]}), do: {[next|prev], rest}

  def prev({[], list}) do
    half = div(length(list), 2)

    nexts = Enum.take(list, half)
    rest = Enum.drop(list, half)

    prev({Enum.reverse(rest), nexts})
  end

  def prev({[prev|rest], nexts}), do: {rest, [prev|nexts]}
end
