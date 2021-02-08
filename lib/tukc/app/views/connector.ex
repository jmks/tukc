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
            table do
              table_row do
                status(connector.state)
              end
            end
          end
        end

        column(size: 6) do
          panel(title: "tasks") do
            tasks(connector.tasks)
          end
        end
      end
    end
  end

  defp title(cluster, connector) do
    label(content: "#{connector.name} @ #{cluster.name} - #{Models.Cluster.url(cluster)}")
  end

  defp status(:no_data), do: table_cell(color: color(:yellow), content: "loading...")
  defp status(:paused), do: table_cell(color: color(:yellow), content: "paused")
  defp status(:unassigned), do: table_cell(color: color(:yellow), content: "unassigned")
  defp status(:running), do: table_cell(color: color(:green), content: "running")
  defp status(:failed), do: table_cell(color: color(:red), content: "failed")

  defp tasks(:no_data), do: status(:no_data)

  defp tasks(tasks) do
    table do
      for {id, state} <- tasks do
        table_row do
          table_cell(content: to_string(id))
          status(state)
        end
      end
    end
  end
end
