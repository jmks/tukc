defmodule Tukc.App.Models.ClusterTab do
  @enforce_keys [:cluster]
  defstruct [:cluster, connectors: :no_data]

  alias Tukc.App.Models.Connector

  def new(cluster) do
    %__MODULE__{cluster: cluster}
  end


  def update_connectors(tab, []) do
    %{tab | connectors: :none}
  end

  def update_connectors(tab, connector_names) do
    new_connectors = Enum.map(connector_names, fn name ->
      Connector.new(name, tab.cluster)
    end)

    %{tab | connectors: new_connectors }
  end
end
