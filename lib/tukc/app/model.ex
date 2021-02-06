defmodule Tukc.App.Model do
  @enforce_keys [:view]
  defstruct [
    :view,
    :clusters,
    :selected_cluster,
    :selected_connector, :selected_connector_index,
    connectors: :no_data,
  ]

  alias Tukc.App.Models.Connector
  alias Tukc.App.{Selection, SelectionList}

  def with_clusters(clusters) do
    sorted_clusters = sort_by_name(clusters) |> SelectionList.new

    %__MODULE__{
      view: :clusters,
      clusters: sorted_clusters,
      selected_cluster: SelectionList.selected(sorted_clusters)
    }
  end

  def next(%{view: :clusters} = model) do
    new_clusters = SelectionList.next(model.clusters)
    selected_cluster = SelectionList.selected(new_clusters)

    %{model | clusters: new_clusters, selected_cluster: selected_cluster }
  end

  def next(%{view: :cluster} = model) do
    {new_selected, new_index} = Selection.next(model.connectors, model.selected_connector_index)

    %{model | selected_connector: new_selected, selected_connector_index: new_index}
  end

  def next(model), do: model

  def previous(%{view: :clusters} = model) do
    new_clusters = SelectionList.previous(model.clusters)
    selected_cluster = SelectionList.selected(new_clusters)

    %{model | clusters: new_clusters, selected_cluster: selected_cluster}
  end

  def previous(%{view: :cluster} = model) do
    {new_selected, new_index} = Selection.previous(model.connectors, model.selected_connector_index)

    %{model | selected_connector: new_selected, selected_connector_index: new_index}
  end

  def previous(model), do: model

  def update_cluster(model, new_cluster) do
    new_clusters = SelectionList.replace(
      model.clusters,
      fn cl -> cl.id == new_cluster.id end,
      new_cluster
    )
    new_selected = SelectionList.selected(new_clusters)

    %{model | clusters: new_clusters, selected_cluster: new_selected }
  end

  def update_connectors(model, cluster_id, connectors)

  def update_connectors(%{selected_cluster: %{id: id}} = model, id, []) do
      %{model | connectors: :none, selected_connector: nil, selected_connector_index: 0}
  end

  def update_connectors(%{selected_cluster: %{id: id}, connectors: :no_data} = model, id, connector_names) do
    connectors =
      connector_names
      |> Enum.sort
      |> Enum.map(&Connector.new(&1))

    %{model | connectors: connectors, selected_connector: hd(connectors), selected_connector_index: 0}
  end

  def update_connectors(%{selected_cluster: %{name: id}} = model, id, connector_names) do
    existing_connectors = Enum.filter(model.connectors, fn conn -> Enum.member?(connector_names, conn.name) end)
    new_connector_names = connector_names -- Enum.map(existing_connectors, fn conn -> conn.name end)
    connectors =
      new_connector_names
      |> Enum.reduce(existing_connectors, fn name, conns ->
        [Connector.new(name) | conns]
      end)
      |> sort_by_name

    selected_connector_index = Enum.find_index(connectors, fn conn -> conn.id == id end) || 0
    selected_connector = Enum.at(connectors, selected_connector_index)

    %{model |
      connectors: connectors,
      selected_connector: selected_connector,
      selected_connector_index: selected_connector_index
    }
  end

  def update_connectors(model, _, _), do: model

  def update_connector(model, connector) do
    index = Enum.find_index(model.connectors, fn conn -> conn.id == connector.id end)

    if index do
      new_connectors = List.replace_at(model.connectors, index, connector)

      %{model | connectors: new_connectors}
    else
      model
    end
  end

  def update_connector_config(model, id, config) do
    index = Enum.find_index(model.connectors, fn conn -> conn.id == id end)

    if index do
      connector = Enum.at(model.connectors, index)
      new_connectors = List.replace_at(model.connectors, index, Connector.update_config(connector, config))

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

  def unselect_connector(model) do
    model
    |> update_connector_config(model.selected_connector.id, nil)
    |> view(:cluster)
  end

  defp sort_by_name(things) do
    Enum.sort_by(things, fn thing -> thing.name end)
  end

  defp clear_connectors(model) do
    %{model | connectors: :no_data, selected_connector: nil, selected_connector_index: nil}
  end

  defp view(model, new_view) do
    %{model | view: new_view}
  end
end
