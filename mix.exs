defmodule Tukc.MixProject do
  use Mix.Project

  def project do
    [
      app: :tukc,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Tukc, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      {:ratatouille, "~> 0.5"},
      {:kconnectex, git: "https://github.com/jmks/kconnectex.git"},
      {:jason, "1.2.2"},
      {:toml, "~> 0.6.1"}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
