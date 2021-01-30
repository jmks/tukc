defmodule Tukc.Configuration do
  alias Tukc.App.Models.Cluster

  @config_filename ".tukc.toml"
  @default_port 8083

  def load(filepath \\ nil) do
    with {:ok, file} <- config_file(filepath),
         {:ok, config} <- Toml.decode_file(file),
         {:ok, config} <- validate_config(config) do
      {:ok, config}
    else
      {:error, {reason, explanation}} ->
        {:error, ["#{to_string(reason)}: #{to_string(explanation)}"]}

      {:error, errors} = error when is_list(errors) ->
        error
    end
  end

  def validate_config(%{"cluster" => clusters}) do
    servers =
      Enum.map(clusters, fn {name, cluster} ->
        validate_cluster(Map.put(cluster, "name", name))
      end)

    errors =
      Enum.filter(servers, fn
        {:ok, _} -> false
        {:error, _} -> true
      end)

    if Enum.any?(errors) do
      {:error, Enum.map(errors, fn {:error, reason} -> reason end)}
    else
      clusters = servers |> Enum.map(fn {:ok, c} -> c end) |> Enum.map(&Cluster.from_map/1)
      {:ok, clusters}
    end
  end

  def validate_config(_) do
    {:error, ["expected clusters defined as tables [cluster.name]"]}
  end

  defp config_file(nil) do
    files = default_files() |> Enum.filter(&File.exists?/1)

    case files do
      [file | _] ->
        {:ok, file}

      _ ->
        message = [
          "could not find configuration file",
          "Looked for: " |
          default_files() |> Enum.map(fn msg -> "  #{msg}" end)
        ]
        {:error, message}
    end
  end

  defp config_file(provided), do: provided

  defp default_files do
    [System.user_home(), File.cwd!()]
    |> Enum.filter(& &1)
    |> Enum.map(fn dir -> Path.join([dir, @config_filename]) end)
  end

  defp validate_cluster(cluster) do
    cond do
      not Map.has_key?(cluster, "host") ->
        {:error, "host is required"}

      not is_binary(cluster["host"]) ->
        {:error, "host must be a string"}

      Map.has_key?(cluster, "port") and not is_integer(cluster["port"]) ->
        {:error, "port must be an integer"}

      not Map.has_key?(cluster, "port") ->
        {:ok, Map.put(cluster, "port", @default_port)}

      true ->
        {:ok, cluster}
    end
  end
end
