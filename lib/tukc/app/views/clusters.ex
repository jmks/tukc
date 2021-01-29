defmodule Tukc.App.Views.Clusters do
  @moduledoc """
  Builds the view of the main loading page.

  Lists clusters and their connectivity.
  """

  alias Tukc.App.Models.Cluster

  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  # @style_selected [
  #   color: color(:black),
  #   background: color(:white)
  # ]


  def render(%{data: errors}) when is_list(errors) do
    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters -- Errors") do
            table do
              for error <- errors do
                table_row do
                  table_cell(content: error)
                end
              end
            end
          end
        end
      end
    end
  end

  def render(%{data: clusters}) do
    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters") do
            table do
              for {_, cluster} <- Enum.sort_by(clusters, fn {name, _} -> name end) do
                table_row do
                  table_cell(content: cluster.name)
                  table_cell(content: Cluster.url(cluster))

                  case cluster.status do
                    :connecting -> table_cell(content: "connecting...")
                    :connected -> table_cell(content: "#{cluster.cluster_id} (#{cluster.kafka_version})")
                    :unreachable -> table_cell(content: "Could not be reached")
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
