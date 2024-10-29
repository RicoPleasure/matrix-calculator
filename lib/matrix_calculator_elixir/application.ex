defmodule MatrixCalculatorElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MatrixCalculatorElixirWeb.Telemetry,
      MatrixCalculatorElixir.Repo,
      {DNSCluster, query: Application.get_env(:matrix_calculator_elixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MatrixCalculatorElixir.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MatrixCalculatorElixir.Finch},
      # Start a worker by calling: MatrixCalculatorElixir.Worker.start_link(arg)
      # {MatrixCalculatorElixir.Worker, arg},
      # Start to serve requests, typically the last entry
      MatrixCalculatorElixirWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MatrixCalculatorElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MatrixCalculatorElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
