defmodule Tukc.App do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.Command

  alias Tukc.Data.KafkaConnect

  alias Tukc.App.Views.{
    Clusters
  }

  # import Ratatouille.Constants, only: [key: 1]
  # @arrow_up key(:arrow_up)
  # @arrow_down key(:arrow_down)
  # @arrow_left key(:arrow_left)
  # @arrow_right key(:arrow_right)

  # @tab_keymap %{
  #   ?? => :help,
  #   ?H => :help
  # }
  # @tab_keys Map.keys(@tab_keymap)
  #
  # @init_cursor %{position: 0, size: 0, continuous: true}

  @impl true
  def init(%{window: window}) do
    case Tukc.Configuration.load() do
      {:ok, clusters} ->
        data = Enum.into(clusters, %{}, fn cluster -> {cluster.name, cluster} end)

        model = %{
          selected_tab: :clusters,
          tabs: %{
            clusters: %{data: data}
          },
          window: window
        }

        commands =
          Enum.map(clusters, fn cluster ->
            Command.new(
              fn -> KafkaConnect.cluster_info(cluster) end,
              {:cluster_updated, cluster.name}
            )
          end)

        {model, Command.batch(commands)}

      {:error, reasons} ->
        %{
          selected_tab: :clusters,
          tabs: %{
            clusters: %{data: reasons}
          }
        }
    end
  end

  @impl true
  def update(model, msg) do
    case msg do
      {{:cluster_updated, name}, new_cluster} ->
        # Process.sleep(:timer.seconds(1))
        put_in(model[:tabs][:clusters][:data][name], new_cluster)

      _ ->
        model
    end
  end

  @impl true
  def render(model) do
    case model.selected_tab do
      :clusters ->
        Clusters.render(model.tabs.clusters)
    end
  end
end
