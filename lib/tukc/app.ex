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
  alias Tukc.App.Models.{
    ClustersTab
  }

  import Ratatouille.Constants, only: [key: 1]
  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
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
        model = %{
          selected_tab: :clusters,
          tabs: %{
            clusters: ClustersTab.new(clusters)
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
            clusters: ClustersTab.error(reasons)
          }
        }
    end
  end

  @impl true
  def update(model, msg) do
    case msg do
      {{:cluster_updated, _}, new_cluster} ->
        # Process.sleep(:timer.seconds(1))
        put_in(model[:tabs][:clusters], ClustersTab.update_cluster(model[:tabs][:clusters], new_cluster))

      {:event, %{ch: ch, key: key}} when ch == ?j or key == @arrow_down ->
        put_in(model[:tabs][model.selected_tab], ClustersTab.cursor_down(model[:tabs][:clusters]))

      {:event, %{ch: ch, key: key}} when ch == ?k or key == @arrow_up ->
        put_in(model[:tabs][model.selected_tab], ClustersTab.cursor_up(model[:tabs][:clusters]))

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
