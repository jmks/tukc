defmodule Tukc.App.Models.ClustersTab do
  @enforce_keys [:data]
  defstruct [:data, :selected_cluster]

  def new(clusters) do
    %__MODULE__{
      data: Enum.into(clusters, %{}, fn cluster -> {cluster.name, cluster} end),
      selected_cluster: 0
    }
  end

  def error(reasons) do
    %__MODULE__{data: {:configuration_error, reasons}}
  end

  def update_cluster(model, new_cluster) do
    new_data = Map.put(model.data, new_cluster.name, new_cluster)

    %{model | data: new_data}
  end

  def cursor_down(model) do
    new_selected = rem(model.selected_cluster + 1, map_size(model.data))

    %{model | selected_cluster: new_selected}
  end

  def cursor_up(model) do
    new_selected = if model.selected_cluster == 0, do: map_size(model.data) - 1, else: model.selected_cluster - 1

    %{model | selected_cluster: new_selected}
  end

  def selected(model) do
    cluster_name =
      model.data
      |> Map.keys
      |> Enum.sort
      |> Enum.at(model.selected_cluster)

    model.data[cluster_name]
  end
end
