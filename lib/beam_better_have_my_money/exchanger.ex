defmodule BEAMBetterHaveMyMoney.Exchanger do
  @moduledoc """
  Regularly queries the API for the exchange rates of
  all possible currency combinations
  """
  use Task, restart: :permanent
  require Logger

  alias BEAMBetterHaveMyMoney.{Config, ExchangeRateStorage}
  alias BEAMBetterHaveMyMoney.Exchanger.ExchangeRate

  @exchange_rate_getter Config.exchange_rate_getter()
  @name :exchange_rate_cache


  @spec start_link({atom() | String.t(), atom() | String.t()}) :: {:ok, pid}
  def start_link({currency1, currency2}, name \\ @name) do
    Task.start_link(__MODULE__, :run, [currency1, currency2, name])
  end

  @spec child_spec({atom(), atom()}) :: Supervisor.child_spec()
  def child_spec({currency1, currency2}) do
    %{
      id: name(currency1, currency2),
      start: {__MODULE__, :start_link, [{currency1, currency2}]}
    }
  end

  @spec run(atom(), atom(), atom()) :: no_return
  def run(from_currency, to_currency, name) do
    case @exchange_rate_getter.query_api_and_decode_json_response(
           from_currency,
           to_currency
         ) do
      {:ok, data} ->
        data
        |> ExchangeRate.new(from_currency, to_currency)
        |> ExchangeRateStorage.store_exchange_rate(name)

      error ->
        Logger.error(
          "Exchange rate for #{from_currency} into #{to_currency} not received. Reason: #{inspect(error)}"
        )
    end

    Process.sleep(:timer.seconds(1))
    run(from_currency, to_currency, name)
  end

  defp name(currency1, currency2) do
    :"exchanger_#{currency1}_#{currency2}"
  end
end
