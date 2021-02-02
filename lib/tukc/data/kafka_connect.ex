defmodule Tukc.Data.KafkaConnect do
  alias Tukc.App.Models.{Cluster, Connector}

  def cluster_info(cluster) do
    client = Kconnectex.client(Cluster.url(cluster))

    case Kconnectex.Cluster.info(client) do
      {:ok, info} ->
        Cluster.connected(cluster, info["kafka_cluster_id"], info["version"])

      {:error, _} ->
        Cluster.unreachable(cluster)
    end
  end

  def connectors(cluster) do
    client = Kconnectex.client(Cluster.url(cluster))

    case Kconnectex.Connectors.list(client) do
      {:ok, connectors} ->
        connectors

      # TODO: errors!
    end
  end

  def connector_status(cluster, connector) do
    client = Kconnectex.client(Cluster.url(cluster))

    case Kconnectex.Connectors.status(client, connector.name) do
      {:ok, status} ->
        Connector.update_status(connector, status)
    end
  end
end
