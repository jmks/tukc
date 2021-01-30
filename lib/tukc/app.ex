defmodule Tukc.App do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.Command

  alias Tukc.Data.KafkaConnect
  alias Tukc.App.Views.{
    Cluster,
    Clusters
  }
  alias Tukc.App.Models.{
    ClusterTab,
    ClustersTab
  }

  import Ratatouille.Constants, only: [key: 1]
  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  # @arrow_left key(:arrow_left)
  @arrow_right key(:arrow_right)

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
        tab = ClustersTab.new(clusters)
        model = %{
          selected_tab: :clusters,
          tabs: %{
            clusters: tab,
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
        {:configuration_error, reasons}
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

      {:event, %{ch: ch, key: key}} when ch == ?l or key == @arrow_right ->
        cluster = ClustersTab.selected(model[:tabs][:clusters])
        cluster_tab = ClusterTab.new(cluster)

        new_model =
          put_in(model[:tabs][:cluster], cluster_tab)
          |> Map.put(:selected_tab, :cluster)
        command = Command.new(fn -> KafkaConnect.connectors(cluster_tab) end, {:connectors_updated, cluster.name})

        {new_model, command}

      {{:connectors_updated, cluster_name}, new_cluster_tab} ->
        if model.tabs.cluster.cluster.name == cluster_name do
          put_in(model[:tabs][:cluster], new_cluster_tab)
        else
          model
        end

      _ ->
        model
    end
  end

  @impl true
  def render({:configuration_error, errors}) do
    import Ratatouille.Constants, only: [color: 1]
    import Ratatouille.View

    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters -- Errors") do
            table do
              for error <- errors do
                table_row(color: color(:red)) do
                  table_cell(content: error)
                end
              end
            end
          end
        end
      end
    end
  end

  @impl true
  def render(model) do
    case model.selected_tab do
      :clusters ->
        Clusters.render(model.tabs.clusters)
      :cluster ->
        Cluster.render(model.tabs.cluster)
    end
  end
end
