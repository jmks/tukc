defmodule Tukc.App.Views.ConfigurationError do
  import Ratatouille.Constants, only: [color: 1]
  import Ratatouille.View

  def render(errors) do
    view do
      row do
        column(size: 12) do
          panel(title: "Kafka Connect clusters -- Errors") do
            table do
              for error <- errors do
                table_row(color: color(:red)) do
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
