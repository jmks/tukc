defmodule Tukc.App.Views.Clusters do
  @moduledoc """
  Builds the view of the main loading page.

  Lists clusters and their connectivity.
  """

  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  # @style_selected [
  #   color: color(:black),
  #   background: color(:white)
  # ]

  def render(%{data: {:ok, clusters}}) do
    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters") do
            table do
              for cluster <- clusters do
                table_row do
                  table_cell(content: cluster.name)
                  table_cell(content: cluster.host)
                  if Map.has_key?(cluster, "connected") do
                    table_cell(content: cluster.connected)
                  else
                    table_cell(content: "connecting...")
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def render(%{data: {:error, errors}}) do
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
end
