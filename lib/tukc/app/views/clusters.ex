defmodule Tukc.App.Views.Clusters do
  @moduledoc """
  Builds the view of the main loading page.

  Lists clusters and their connectivity.
  """

  alias Tukc.App.Models.Cluster

  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  @style_selected [
    color: color(:black),
    background: color(:white)
  ]

  def render(clusters, selected_cluster_id) do
    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters") do
            table do
              for cluster <- clusters do
                selected? = cluster.id == selected_cluster_id

                table_row(if selected?, do: @style_selected, else: []) do
                  table_cell(content: cluster.name)
                  table_cell(content: Cluster.url(cluster))

                  case cluster.status do
                    :connecting -> table_cell(color: color(:yellow), content: "connecting...")
                    :connected -> table_cell(color: color(:green), content: "#{cluster.cluster_id} (#{cluster.kafka_version})")
                    :unreachable -> table_cell(color: color(:red), content: "Could not be reached")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
