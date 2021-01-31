defmodule Tukc.ConfigurationTest do
  use ExUnit.Case, async: true

  alias Tukc.Configuration
  alias Tukc.App.Models.Cluster

  test "host and port are valid" do
    config = %{"cluster" => %{"local" => %{"host" => "localhost", "port" => 8080}}}

    assert {:ok, [cluster("local", "localhost", 8080)]} == Configuration.validate_config(config)
  end

  test "default port is used when not supplied" do
    config = %{"cluster" => %{"local" => %{"host" => "localhost"}}}

    assert {:ok, [cluster("local", "localhost", 8083)]} == Configuration.validate_config(config)
  end

  test "invalid without host" do
    config = %{"cluster" => %{"local" => %{}}}

    assert {:error, ["host is required"]} == Configuration.validate_config(config)
  end

  test "invalid when host is not a string" do
    config = %{"cluster" => %{"local" => %{"host" => 1337}}}

    assert {:error, ["host must be a string"]} == Configuration.validate_config(config)
  end

  test "invalid when port is not an integer" do
    config = %{"cluster" => %{"local" => %{"host" => "localhost", "port" => 80.80}}}

    assert {:error, ["port must be an integer"]} == Configuration.validate_config(config)
  end

  defp cluster(name, host, port) do
    Cluster.from_map(%{"name" => name, "host" => host, "port" => port})
  end
end
