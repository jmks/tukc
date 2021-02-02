defmodule Tukc.App.Model do
  @enforce_keys [:selected]
  defstruct [
    :selected,
    :clusters,
    :selected_cluster, :selected_cluster_index,
    connectors: :no_data
  ]

  alias Tukc.App.Models.Connector

  def with_clusters(clusters) do
    sorted_clusters = sort_by_name(clusters)

    %__MODULE__{
      selected: :clusters,
      clusters: sorted_clusters,
      selected_cluster_index: 0,
      selected_cluster: List.first(sorted_clusters)
    }
  end

  def next_cluster(%{selected: :clusters} = model) do
    new_index = rem(model.selected_cluster_index + 1, length(model.clusters))
    new_selected = Enum.at(model.clusters, new_index)

    %{model | selected_cluster: new_selected, selected_cluster_index: new_index}
  end

  def previous_cluster(%{selected: :clusters} = model) do
    new_index = if model.selected_cluster_index == 0, do: length(model.clusters) - 1, else: model.selected_cluster_index - 1
    new_selected = Enum.at(model.clusters, new_index)

    %{model | selected_cluster: new_selected, selected_cluster_index: new_index}
  end

  def update_cluster(model, new_cluster) do
    index = Enum.find_index(model.clusters, fn cluster -> cluster.name == new_cluster.name end)
    new_clusters = List.replace_at(model.clusters, index, new_cluster)
    new_selected = Enum.at(new_clusters, model.selected_cluster_index)

    %{model | clusters: new_clusters, selected_cluster: new_selected }
  end

  def update_connectors(model, cluster, connectors) do
    if cluster == model.selected_cluster.name do
      %{model | connectors: Enum.map(connectors, &Connector.new(&1))}
    else
      model
    end
  end

  def unselect_cluster(model) do
    %{model | connectors: :no_data, selected: :clusters}
  end

  defp sort_by_name(things) do
    Enum.sort_by(things, fn thing -> thing.name end)
  end
end
