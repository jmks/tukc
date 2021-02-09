# Tukc

A **Terminal Ui for Kafka Connect**.

Currently under development.

## TODO

* auto-update every 2 seconds (configurable)
* auto-update probably needs a caching layer
* plugins view
* logging view
* connector commands
* tasks commands
* help overlay
* status bar
* tests (!!)
* state machine for view transitions (could ease parts of Update)?
  * cluster -- select cluster --> cluster
  * cluster -- back --> clusters
  * cluster -- p --> plugins
  * plugins -- back --> cluster
  * cluster -- l --> logging
  * logging -- back --> cluster
  * cluster -- select connector --> connector
  * connector -- back -> cluster

## Development

```
$ mix deps.get
$ mix run --no-halt
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tukc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tukc, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tukc](https://hexdocs.pm/tukc).
