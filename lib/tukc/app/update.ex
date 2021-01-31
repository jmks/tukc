defmodule Tukc.App.Update do
  alias Ratatouille.Runtime.Command

  alias Tukc.App.Models.State
  alias Tukc.Data.KafkaConnect

  def update(%{selected: :clusters} = state) do
    load_clusters =
      Enum.map(state.clusters, fn cluster ->
        Command.new(
          fn -> KafkaConnect.cluster_info(cluster) end,
          {:cluster_updated, cluster.name}
        )
      end)

    {state, Command.batch(load_clusters)}
  end

  def cursor_down(%{selected: :clusters} = state) do
    State.next_cluster(state)
  end

  def cursor_up(%{selected: :clusters} = state) do
    State.previous_cluster(state)
  end

  def select_cluster(state) do
    new_state = Map.put(state, :selected, :cluster)

    load_connectors = Command.new(
      fn -> KafkaConnect.connectors(state.selected_cluster) end,
      {:connectors_updated, state.selected_cluster.name}
    )

    {new_state, load_connectors}
  end

  def update_connectors(state, cluster, connectors) do
    State.update_connectors(state, cluster, connectors)
  end
end
