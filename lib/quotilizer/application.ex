defmodule Quotilizer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, client} = ExIRC.start_link!

    children = [
      # Start the Ecto repository
      Quotilizer.Repo,
      # Start the Telemetry supervisor
      QuotilizerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Quotilizer.PubSub},
      # Start the Endpoint (http/https)
      QuotilizerWeb.Endpoint,
      # Start a worker by calling: Quotilizer.Worker.start_link(arg)
      # {Quotilizer.Worker, arg}
      # Define workers and child supervisors to be supervised
      worker(TwitchConnectionHandler, [client]),
      # here's where we specify the channels <t></t>o join:
      worker(TwitchLoginHandler, [client, ["#a_seagull"]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Quotilizer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QuotilizerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
