defmodule Tukc.App.States do
  @states %{
    "RUNNING" => :running,
    "PAUSED" => :paused,
    "FAILED" => :failed,
    "UNASSIGNED" => :unassigned
  }

  def parse!(state) do
    Map.fetch!(@states, state)
  end
end
