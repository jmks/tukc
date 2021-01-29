defmodule Tukc.Data.KafkaConnect do
  alias Tukc.App.Models.Cluster

  def cluster_info(cluster) do
    client = Kconnectex.client(Cluster.url(cluster))

    case Kconnectex.Cluster.info(client) do
      {:ok, info} ->
        Cluster.connected(cluster, info["kafka_cluster_id"], info["version"])

      {:error, _} ->
        Cluster.unreachable(cluster)
    end
  end
end
