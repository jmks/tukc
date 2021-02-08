defmodule Tukc.App.Model do
  @enforce_keys [:view]
  defstruct [
    :view,
    :clusters,
    :selected_cluster,
    :selected_connector,
    connectors: :no_data
  ]

  alias Tukc.App.Models.Connector
  alias Tukc.App.SelectionList

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
    new_connectors = SelectionList.next(model.connectors)
    new_selected = SelectionList.selected(new_connectors)

    %{model | connectors: new_connectors, selected_connector: new_selected}
  end

  def next(model), do: model

  def previous(%{view: :clusters} = model) do
    new_clusters = SelectionList.previous(model.clusters)
    selected_cluster = SelectionList.selected(new_clusters)

    %{model | clusters: new_clusters, selected_cluster: selected_cluster}
  end

  def previous(%{view: :cluster} = model) do
    new_connectors = SelectionList.previous(model.connectors)
    new_selected = SelectionList.selected(new_connectors)

    %{model | connectors: new_connectors, selected_connector: new_selected}
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
      %{model | connectors: :none, selected_connector: nil}
  end

  def update_connectors(%{selected_cluster: %{id: id}, connectors: :no_data} = model, id, connector_names) do
    connectors =
      connector_names
      |> Enum.sort
      |> Enum.map(&Connector.new(&1))
      |> SelectionList.new
    new_selected = SelectionList.selected(connectors)

    %{model | connectors: connectors, selected_connector: new_selected}
  end

  def update_connectors(%{selected_cluster: %{name: id}} = model, id, connector_names) do
    existing_connectors =
      model.connectors
      |> SelectionList.to_list
      |> Enum.filter(fn conn -> Enum.member?(connector_names, conn.name) end)
    existing_connector_names = Enum.map(existing_connectors, fn conn -> conn.name end)
    new_connector_names = connector_names -- existing_connector_names

    connectors =
      new_connector_names
      |> Enum.reduce(existing_connectors, fn name, conns ->
        [Connector.new(name) | conns]
      end)
      |> sort_by_name
      |> SelectionList.new
      |> SelectionList.select(fn conn -> conn.id == id end)
    selected_connector = SelectionList.selected(connectors)

    %{model |
      connectors: connectors,
      selected_connector: selected_connector
    }
  end

  def update_connectors(model, _, _), do: model

  def update_connector(model, connector) do
    new_connectors = SelectionList.replace(
      model.connectors,
      fn conn -> conn.id == connector.id end,
      connector
    )

    %{model | connectors: new_connectors}
  end

  def update_connector_config(model, id, config) do
    new_connectors = SelectionList.replace(
      model.connectors,
      fn conn -> conn.id == id end,
      &Connector.update_config(&1, config)
    )

    %{model | connectors: new_connectors}
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
    %{model | connectors: :no_data, selected_connector: nil}
  end

  defp view(model, new_view) do
    %{model | view: new_view}
  end
end
