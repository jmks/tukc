defmodule Tukc.App.Models.Connector do
  @states %{
    "RUNNING" => :running,
    "PAUSED" => :paused,
    "FAILED" => :failed,
    "UNASSIGNED" => :unassigned
  }

  @enforce_keys [:name, :id]
  defstruct [
    :name, :id,
    :type, :config,
    jobs: :no_data, # {id, state}
    state: :no_data
  ]

  def new(name) do
    %__MODULE__{name: name, id: make_ref()}
  end

  def update_status(connector, status) do
    %{ connector |
       state: Map.get(@states, status["connector"]["state"]),
       type: status["type"],
       jobs: Enum.map(status["tasks"], fn task ->
         {task["id"], Map.get(@states, task["state"])}
       end)
    }
  end

  def update_config(connector, config) do
    %{connector | config: config}
  end
end
