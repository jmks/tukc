defmodule Tukc.App do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  alias Tukc.App.Model
  alias Tukc.App.Update
  alias Tukc.App.Views.{
    Cluster,
    Clusters,
    ConfigurationError
  }

  import Ratatouille.Constants, only: [key: 1]
  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  @arrow_left key(:arrow_left)
  @arrow_right key(:arrow_right)

  # @tab_keymap %{
  #   ?? => :help,
  #   ?H => :help
  # }
  # @tab_keys Map.keys(@tab_keymap)
  #
  # @init_cursor %{position: 0, size: 0, continuous: true}

  @impl true
  def init(_) do
    case Tukc.Configuration.load() do
      {:ok, clusters} ->
        model = Model.with_clusters(clusters)
        Update.update(model)

      {:error, reasons} ->
        {:configuration_error, reasons}
    end
  end

  @impl true
  def update(model, msg) do
    case msg do
      {{:cluster_updated, _}, new_cluster} ->
        # Process.sleep(500)
        Model.update_cluster(model, new_cluster)

      {{:connectors_updated, cluster_name}, connectors} ->
        # Process.sleep(500)
        Update.update_connectors(model, cluster_name, connectors)

      {:event, %{ch: ch, key: key}} when ch == ?j or key == @arrow_down ->
        Update.cursor_down(model)

      {:event, %{ch: ch, key: key}} when ch == ?k or key == @arrow_up ->
        Update.cursor_up(model)

      {:event, %{ch: ch, key: key}} when ch == ?l or key == @arrow_right ->
        Update.select(model)

      {:event, %{ch: ch, key: key}} when ch == ?h or key == @arrow_left ->
        Update.unselect(model)

      _ ->
        model
    end
  end

  @impl true
  def render({:configuration_error, errors}) do
    ConfigurationError.render(errors)
  end

  @impl true
  def render(model) do
    case model.selected do
      :clusters ->
        Clusters.render(model.clusters, model.selected_cluster)

      :cluster ->
        Cluster.render(model.selected_cluster, model.connectors)
    end
  end
end
