defmodule Tukc.App.Update do
  alias Ratatouille.Runtime.Command

  alias Tukc.App.Models.State
  alias Tukc.Data.KafkaConnect

  def update(%{selected: :clusters} = state) do
    {state, load_clusters(state.clusters)}
  end

  def cursor_down(%{selected: :clusters} = state) do
    State.next_cluster(state)
  end

  def cursor_up(%{selected: :clusters} = state) do
    State.previous_cluster(state)
  end

  def select(%{selected: :clusters, selected_cluster: %{status: :connected}} = state) do
    new_state = Map.put(state, :selected, :cluster)
    command = load_connectors(state.selected_cluster)

    {new_state, command}
  end

  def select(state), do: state

  def unselect(%{selected: :cluster} = model) do
    new_state = State.unselect_cluster(model)
    commands = load_clusters(model.clusters)

    {new_state, commands}
  end


  def update_connectors(state, cluster, connectors) do
    State.update_connectors(state, cluster, connectors)
  end

  defp load_clusters(clusters) do
    clusters
    |> Enum.map(fn cluster ->
      Command.new(
        fn -> KafkaConnect.cluster_info(cluster) end,
        {:cluster_updated, cluster.name}
      )
    end)
    |> Command.batch
  end

  defp load_connectors(cluster) do
    Command.new(
      fn -> KafkaConnect.connectors(cluster) end,
      {:connectors_updated, cluster.name}
    )
  end
end
