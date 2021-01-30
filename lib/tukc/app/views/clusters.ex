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

  def render(%{data: clusters, selected_cluster: selected}) do
    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters") do
            table do
              for {{_, cluster}, index} <- clusters |> Enum.sort_by(fn {name, _} -> name end) |> Enum.with_index do
                selected? = index == selected

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
