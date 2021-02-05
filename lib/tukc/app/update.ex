defmodule Tukc.App.Update do
  alias Ratatouille.Runtime.Command

  alias Tukc.App.Model
  alias Tukc.Data.KafkaConnect

  def update(%{selected: :clusters} = model) do
    {model, load_clusters(model.clusters)}
  end

  def cursor_down(model), do: Model.next(model)

  def cursor_up(model), do: Model.previous(model)

  def select(%{selected: :clusters, selected_cluster: %{status: :connected}} = model) do
    new_model = Map.put(model, :selected, :cluster)
    command = load_connector_for_cluster(model.selected_cluster)

    {new_model, command}
  end

  def select(%{selected: :cluster} = model) do
    new_model = Map.put(model, :selected, :connector)
    command = load_connector_details(model.selected_cluster, model.selected_connector)

    {new_model, command}
  end

  def select(model), do: model

  def unselect(%{selected: :cluster} = model) do
    new_model = Model.unselect_cluster(model)
    command = load_clusters(model.clusters)

    {new_model, command}
  end

  def unselect(model), do: model

  def update_connectors(model, cluster, []) do
    Model.update_connectors(model, cluster, [])
  end

  def update_connectors(model, cluster, connectors) do
    new_model = Model.update_connectors(model, cluster, connectors)
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
    |> Enum.map(fn cluster ->
      Command.new(
        fn -> KafkaConnect.cluster_info(cluster) end,
        {:cluster_updated, cluster.name}
      )
    end)
    |> Command.batch
  end

  defp load_connector_for_cluster(cluster) do
    Command.new(
      fn -> KafkaConnect.connectors(cluster) end,
      {:connectors_updated, cluster.name}
    )
  end

  defp load_connectors(cluster, connectors) do
    connectors
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
