defmodule Tukc do
  @moduledoc """
  Documentation for `Tukc`.
  """

  use Application

  def start(_type, _args) do
    runtime_opts = [
      app: Tukc.App,
      shutdown: {:application, :tukc}
    ]

    children = [
      {Ratatouille.Runtime.Supervisor, runtime: runtime_opts}
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: Tukc.Supervisor
    )
  end

  def stop(_model) do
    # Do a hard shutdown after the application has been stopped.
    #
    # Another, perhaps better, option is `System.stop/0`, but this results in a
    # rather annoying lag when quitting the terminal application.
    System.halt()
  end

  @version Mix.Project.config()[:version]

  def version, do: @version
end
