defmodule Buenavida.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BuenavidaWeb.Telemetry,
      Buenavida.Repo,
      {DNSCluster, query: Application.get_env(:buenavida, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Buenavida.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Buenavida.Finch},
      # Start a worker by calling: Buenavida.Worker.start_link(arg)
      # {Buenavida.Worker, arg},
      # Start to serve requests, typically the last entry
      BuenavidaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Buenavida.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuenavidaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
