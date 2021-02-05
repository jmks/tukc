defmodule Tukc.Data.KafkaConnect do
  alias Tukc.App.Models.{Cluster, Connector}

  def cluster_info(cluster) do
    case Kconnectex.Cluster.info(client(cluster)) do
      {:ok, info} ->
        Cluster.connected(cluster, info["kafka_cluster_id"], info["version"])

      {:error, _} ->
        Cluster.unreachable(cluster)
    end
  end

  def connectors(cluster) do
    case Kconnectex.Connectors.list(client(cluster)) do
      {:ok, connectors} ->
        connectors

      # TODO: errors!
    end
  end

  def connector_status(cluster, connector) do
    case Kconnectex.Connectors.status(client(cluster), connector.name) do
      {:ok, status} ->
        Connector.update_status(connector, status)

      # TODO: errors!
    end
  end

  def connector_config(cluster, connector) do
    case Kconnectex.Connectors.config(client(cluster), connector.name) do
      {:ok, config} ->
        config

      # TODO: errors!
    end
  end

  defp client(cluster), do: Kconnectex.client(Cluster.url(cluster))
end
