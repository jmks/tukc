defmodule Tukc.App.Models.Connector do
  @states %{
    "RUNNING" => :running
  }

  @enforce_keys [:name]
  defstruct [
    :name,
    :type,
    jobs: :no_data, # {id, state}
    state: :no_data
  ]

  def new(name) do
    %__MODULE__{name: name}
  end
end
