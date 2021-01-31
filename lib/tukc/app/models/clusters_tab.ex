defmodule Tukc.App.Models.ClustersTab do
  @enforce_keys [:data]
  defstruct [:data, :selected_cluster]

  def new(clusters) do
    %__MODULE__{
      data: Enum.into(clusters, %{}, fn cluster -> {cluster.name, cluster} end),
      selected_cluster: 0
    }
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
