defmodule Tukc.App.Models.Connector do
  @states %{
    "RUNNING" => :running,
    "PAUSED" => :paused,
    "FAILED" => :failed,
    "UNASSIGNED" => :unassigned
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

  def update_status(connector, status) do
    %{ connector |
       state: Map.get(@states, status["connector"]["state"]),
       type: status["type"],
       jobs: Enum.map(status["tasks"], fn task ->
         {task["id"], Map.get(@states, task["state"])}
       end)
    }
  end
end
