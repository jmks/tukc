defmodule Tukc.App do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  # alias Ratatouille.Runtime.{Command, Subscription}

  alias Tukc.App.Views.{
    Clusters,
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

  @init_cursor %{position: 0, size: 0, continuous: true}

  @impl true
  def init(%{window: window}) do
    model = %{
      selected_tab: :clusters,
      tabs: %{
        clusters: %{
          data: Tukc.Configuration.load(),
          cursor_x: @init_cursor,
          cursor_y: @init_cursor
        }
      },
      window: window
    }

    model
  end

  @impl true
  def update(model, _msg) do
    model
  end

  @impl true
  def render(model) do
    case model.selected_tab do
      :clusters ->
        Clusters.render(model.tabs.clusters)
    end
  end
end
