defmodule Tukc.App.Models.Cluster do
  @statuses [:connecting, :connected, :unreachable]

  @enforce_keys [:name, :id, :host, :port]
  defstruct [
    :name, :id, :host, :port,
    :cluster_id, :kafka_version,
    status: :connecting
  ]

  def from_map(%{"name" => name, "host" => host, "port" => port}) do
    %__MODULE__{name: name, id: make_ref(), host: host, port: port}
  end

  def url(cluster) do
    Enum.join([cluster.host, ":", cluster.port], "")
  end

  def connected(cluster, id, kafka_version) do
    %{cluster | status: :connected, cluster_id: id, kafka_version: kafka_version}
  end

  def unreachable(cluster) do
    %{cluster | status: :unreachable}
  end
end
