defmodule Tukc.App.Models.Cluster do
  @enforce_keys [:name, :host, :port]
  defstruct [:name, :host, :port, :status]

  def from_map(%{"name" => name, "host" => host, "port" => port}) do
    %__MODULE__{name: name, host: host, port: port}
  end
end
