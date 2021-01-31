defmodule Tukc.App.Views.Cluster do
  @moduledoc """
  Builds the view of a specific cluster.

  Lists connectors and their status.
  """

  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  alias Tukc.App.Models

  # @style_selected [
  #   color: color(:black),
  #   background: color(:white)
  # ]

  def render(cluster, :no_data) do
    view do
      title(cluster)
      row do
        column(size: 12) do
          panel(title: "Connectors") do
            table do
              table_row(color: color(:yellow)) do
                table_cell(content: "loading...")
              end
            end
          end
        end
      end
    end
  end

  def render(cluster, []) do
    view do
      title(cluster)
      row do
        column(size: 12) do
          panel(title: "Connectors") do
            table do
              table_row(color: color(:red)) do
                table_cell(content: "No connectors")
              end
            end
          end
        end
      end
    end
  end

  def render(cluster, connectors) do
    view do
      title(cluster)
      row do
        column(size: 12) do
          panel(title: "Connectors") do
            table do
              for connector <- connectors do
                table_row do
                  table_cell(content: connector)
                end
              end
            end
          end
        end
      end
    end
  end

  defp title(cluster) do
    label(content: "Cluster: #{cluster.name} - #{Models.Cluster.url(cluster)}")
  end
end
