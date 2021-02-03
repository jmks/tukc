defmodule Tukc.App.Views.Cluster do
  @moduledoc """
  Builds the view of a specific cluster.

  Lists connectors and their status.
  """

  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  alias Tukc.App.Models

  @style_selected [
    color: color(:black),
    background: color(:white)
  ]

  def render(cluster, :no_data, nil) do
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

  def render(cluster, :none, nil) do
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

  def render(cluster, connectors, selected_connector) do
    view do
      title(cluster)
      row do
        column(size: 12) do
          panel(title: "Connectors") do
            table do
              table_row(attributes: [:bold]) do
                table_cell(content: "Connector")
                table_cell(content: "State")
                table_cell(content: "Tasks")
              end

              for connector <- connectors do
                selected? = connector.name == selected_connector.name


                table_row(if selected?, do: @style_selected, else: []) do
                  table_cell(content: connector.name)

                  case connector.state do
                    :no_data ->
                      table_cell(color: color(:yellow), content: "loading...")
                    :running ->
                      table_cell(color: color(:green), content: "running")
                  end

                  task_indicator(connector.jobs)
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

  defp task_indicator(:no_data), do: table_cell(color: color(:yellow), content: "loading...")

  defp task_indicator(jobs) do
    states = MapSet.new(jobs |> Enum.map(fn {_, state} -> state end))

    cond do
      :running in states and MapSet.size(states) == 1 ->
        table_cell(color: color(:green), content: "OK")
      not MapSet.member?(states, :failed) ->
        table_cell(color: color(:yellow), content: "OK")
      true ->
        table_cell(color: color(:red), content: "FAILED")
    end
  end
end
