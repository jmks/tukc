defmodule Tukc.App.Views.Connector do
  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  alias Tukc.App.Models

  def render(cluster, connector) do
    view do
      title(cluster, connector)
      row do
        column(size: 6) do
          panel(title: "status") do
            status(connector.state)
          end
        end

        column(size: 6) do
          panel(title: "tasks") do
            label(content: "not implemented")
          end
        end
      end
    end
  end

  defp title(cluster, connector) do
    label(content: "#{connector.name} @ #{cluster.name} - #{Models.Cluster.url(cluster)}")
  end

  defp status(:no_data), do: label(color: color(:yellow), content: "loading...")
  defp status(:paused), do: label(color: color(:yellow), content: "paused")
  defp status(:unassigned), do: label(color: color(:yellow), content: "unassigned")
  defp status(:running), do: label(color: color(:green), content: "running")
  defp status(:failed), do: label(color: color(:red), content: "failed")
end
