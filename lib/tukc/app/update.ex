defmodule Tukc.App.Update do
  alias Ratatouille.Runtime.Command

  alias Tukc.App.SelectionList
  alias Tukc.App.Model
  alias Tukc.Data.KafkaConnect

  def update(%{view: :clusters} = model) do
    {model, load_clusters(model.clusters)}
  end

  def cursor_down(model), do: Model.next(model)

  def cursor_up(model), do: Model.previous(model)

  def select(%{view: :clusters, selected_cluster: %{status: :connected}} = model) do
    new_model = Map.put(model, :view, :cluster)
    command = load_connectors(model.selected_cluster)

    {new_model, command}
  end

  def select(%{view: :cluster} = model) do
    new_model = Map.put(model, :view, :connector)
    command = load_connector_details(model.selected_cluster, model.selected_connector)

    {new_model, command}
  end

  def select(model), do: model

  def unselect(%{view: :cluster} = model) do
    new_model = Model.unselect_cluster(model)
    command = load_clusters(model.clusters)

    {new_model, command}
  end

  def unselect(%{view: :connector} = model) do
    new_model = Model.unselect_connector(model)
    command = load_connectors(model.selected_cluster)

    {new_model, command}
  end

  def unselect(model), do: model

  def update_connectors(model, cluster_id, []) do
    Model.update_connectors(model, cluster_id, [])
  end

  def update_connectors(model, cluster_id, connectors) do
    new_model = Model.update_connectors(model, cluster_id, connectors)
    command = load_connectors(new_model.selected_cluster, new_model.connectors)

    {new_model, command}
  end

  def update_connector(model, connector) do
    Model.update_connector(model, connector)
  end

  def update_connector_config(model, id, config) do
    Model.update_connector_config(model, id, config)
  end

  defp load_clusters(clusters) do
    clusters
    |> SelectionList.to_list
    |> Enum.map(fn cluster ->
      Command.new(
        fn -> KafkaConnect.cluster_info(cluster) end,
        :cluster_updated
      )
    end)
    |> Command.batch
  end

  defp load_connectors(cluster) do
    Command.new(
      fn -> KafkaConnect.connectors(cluster) end,
      {:connectors_updated, cluster.id}
    )
  end

  defp load_connectors(cluster, connectors) do
    connectors
    |> SelectionList.to_list
    |> Enum.map(fn connector ->
      Command.new(
        fn -> KafkaConnect.connector_status(cluster, connector) end,
        :connector_updated
      )
    end)
    |> Command.batch
  end

  defp load_connector_details(cluster, connector) do
    Command.new(
      fn -> KafkaConnect.connector_config(cluster, connector) end,
      {:connector_config_updated, connector.id}
    )
  end
end
