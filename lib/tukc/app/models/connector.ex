defmodule Tukc.App.Models.Connector do
  @enforce_keys [:cluster, :name]
  defstruct [:cluster, :name]

  def new(name, cluster) do
    %__MODULE__{name: name, cluster: cluster}
  end
end
