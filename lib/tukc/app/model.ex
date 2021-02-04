defmodule Tukc.App.Model do
  @enforce_keys [:selected]
  defstruct [
    :selected,
    :clusters,
    :selected_cluster, :selected_cluster_index,
    :selected_connector, :selected_connector_index,
    connectors: :no_data,
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

  def next(%{selected: :clusters} = model) do
    new_index = rem(model.selected_cluster_index + 1, length(model.clusters))
    new_selected = Enum.at(model.clusters, new_index)

    %{model | selected_cluster: new_selected, selected_cluster_index: new_index}
  end

  def next(%{selected: :cluster} = model) do
    new_index = rem(model.selected_connector_index + 1, length(model.connectors))
    new_selected = Enum.at(model.connectors, new_index)

    %{model | selected_connector: new_selected, selected_connector_index: new_index}
  end

  def previous(%{selected: :clusters} = model) do
    new_index = if model.selected_cluster_index == 0, do: length(model.clusters) - 1, else: model.selected_cluster_index - 1
    new_selected = Enum.at(model.clusters, new_index)

    %{model | selected_cluster: new_selected, selected_cluster_index: new_index}
  end

  def previous(%{selected: :cluster} = model) do
    new_index = if model.selected_connector_index == 0, do: length(model.connectors) - 1, else: model.selected_connector_index - 1
    new_selected = Enum.at(model.connectors, new_index)

    %{model | selected_connector: new_selected, selected_connector_index: new_index}
  end

  def update_cluster(model, new_cluster) do
    index = Enum.find_index(model.clusters, fn cluster -> cluster.name == new_cluster.name end)
    new_clusters = List.replace_at(model.clusters, index, new_cluster)
    new_selected = Enum.at(new_clusters, model.selected_cluster_index)

    %{model | clusters: new_clusters, selected_cluster: new_selected }
  end

  def update_connectors(model, cluster, []) do
    if cluster == model.selected_cluster.name do
      %{model | connectors: :none}
    else
      model
    end
  end

  def update_connectors(model, cluster, connector_names) do
    if cluster == model.selected_cluster.name do
      connectors =
        connector_names
        |> Enum.sort
        |> Enum.map(&Connector.new(&1))

      %{model | connectors: connectors, selected_connector: hd(connectors), selected_connector_index: 0}
    else
      model
    end
  end

  def update_connector(model, connector) do
    index = Enum.find_index(model.connectors, fn conn -> conn.name == connector.name end)

    if index do
      new_connectors = List.replace_at(model.connectors, index, connector)

      %{model | connectors: new_connectors}
    else
      model
    end
  end

  def unselect_cluster(model) do
    model
    |> clear_connectors
    |> view(:clusters)
  end

  defp sort_by_name(things) do
    Enum.sort_by(things, fn thing -> thing.name end)
  end

  defp clear_connectors(model) do
    %{model | connectors: :no_data, selected_connector: nil, selected_connector_index: nil}
  end

  defp view(model, new_view) do
    %{model | selected: new_view}
  end
end
