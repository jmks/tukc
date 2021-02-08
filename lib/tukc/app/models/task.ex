defmodule Tukc.App.Models.Task do
  @enforce_keys [:id, :state, :worker_id]
  defstruct [:id, :state, :worker_id]

  alias Tukc.App.States

  def from_map(task_map) do
    new(task_map["id"], States.parse!(task_map["state"]), task_map["worker_id"])
  end

  def new(id, state, worker_id) do
    %__MODULE__{id: id, state: state, worker_id: worker_id}
  end
end
