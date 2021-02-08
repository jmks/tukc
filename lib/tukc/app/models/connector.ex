defmodule Tukc.App.Models.Connector do
  @enforce_keys [:name, :id]
  defstruct [
    :name, :id,
    :type, :config,
    tasks: :no_data, # {id, state}
    state: :no_data
  ]

  alias Tukc.App.States

  def new(name) do
    %__MODULE__{name: name, id: make_ref()}
  end

  def update_status(connector, status) do
    %{ connector |
       state: States.parse!(status["connector"]["state"]),
       type: status["type"],
       tasks: Enum.map(status["tasks"], fn task ->
         {task["id"], States.parse!(task["state"])}
       end
    }
  end

  def update_config(connector, config) do
    %{connector | config: config}
  end
end
