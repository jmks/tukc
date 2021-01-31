defmodule Tukc.App.Models.State do
  @enforce_keys [:selected]
  defstruct [
    :selected,
    :clusters,
    :selected_cluster, :selected_cluster_index,
    connectors: :no_data
  ]

  def with_clusters(clusters) do
    sorted_clusters = sort_by_name(clusters)

    %__MODULE__{
      selected: :clusters,
      clusters: sorted_clusters,
      selected_cluster_index: 0,
      selected_cluster: List.first(sorted_clusters)
    }
  end

  def next_cluster(%{selected: :clusters} = state) do
    new_index = rem(state.selected_cluster_index + 1, length(state.clusters))
    new_selected = Enum.at(state.clusters, new_index)

    %{state | selected_cluster: new_selected, selected_cluster_index: new_index}
  end

  def previous_cluster(%{selected: :clusters} = state) do
    new_index = if state.selected_cluster_index == 0, do: length(state.clusters) - 1, else: state.selected_cluster_index - 1
    new_selected = Enum.at(state.clusters, new_index)

    %{state | selected_cluster: new_selected, selected_cluster_index: new_index}
  end

  def update_cluster(state, new_cluster) do
    index = Enum.find_index(state.clusters, fn cluster -> cluster.name == new_cluster.name end)
    new_clusters = List.replace_at(state.clusters, index, new_cluster)
    new_selected = Enum.at(state.clusters, state.selected_cluster_index)

    %{state | clusters: new_clusters, selected_cluster: new_selected }
  end

  def update_connectors(state, cluster, connectors) do
    if cluster == state.selected_cluster.name do
      %{state | connectors: connectors}
    else
      state
    end
  end

  defp sort_by_name(things) do
    Enum.sort_by(things, fn thing -> thing.name end)
  end
end
