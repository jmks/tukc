defmodule Tukc.Data.KafkaConnect do
  alias Tukc.App.Models.{Cluster, ClusterTab}

  def cluster_info(cluster) do
    client = Kconnectex.client(Cluster.url(cluster))

    case Kconnectex.Cluster.info(client) do
      {:ok, info} ->
        Cluster.connected(cluster, info["kafka_cluster_id"], info["version"])

      {:error, _} ->
        Cluster.unreachable(cluster)
    end
  end

  def connectors(cluster_tab) do
    client = Kconnectex.client(Cluster.url(cluster_tab.cluster))

    case Kconnectex.Connectors.list(client) do
      {:ok, connectors} ->
        ClusterTab.update_connectors(cluster_tab, connectors)
    end
  end
end
