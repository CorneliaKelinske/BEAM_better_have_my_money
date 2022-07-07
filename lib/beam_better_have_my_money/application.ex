defmodule BEAMBetterHaveMyMoney.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias BEAMBetterHaveMyMoney.Config
  @currencies Config.currencies()

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        BEAMBetterHaveMyMoney.Repo,
        # Start the Telemetry supervisor
        BEAMBetterHaveMyMoneyWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: BEAMBetterHaveMyMoney.PubSub},
        # Start the Endpoint (http/https)
        BEAMBetterHaveMyMoneyWeb.Endpoint
        # Start a worker by calling: BEAMBetterHaveMyMoney.Worker.start_link(arg)
        # {BEAMBetterHaveMyMoney.Worker, arg}
      ] ++ exchangers()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BEAMBetterHaveMyMoney.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BEAMBetterHaveMyMoneyWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def exchangers do
    for currency1 <- @currencies,
        currency2 <- @currencies,
        currency2 != currency1 do
      BEAMBetterHaveMyMoney.Exchanger.child_spec({currency1, currency2})
    end
  end
end
