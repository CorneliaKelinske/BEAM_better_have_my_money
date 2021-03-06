defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.ExchangeRate do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts.Wallet, Config}
  alias BEAMBetterHaveMyMoney.{Exchanger.ExchangeRate, ExchangeRateStorage}

  @exchange_rate_cache Config.exchange_rate_cache()

  @type resolution :: Absinthe.Resolution.t()

  @type currency :: Wallet.currency()
  @type exchange_rate :: ExchangeRate.t()
  @type params :: %{from_currency: currency(), to_currency: currency()}

  @spec get_exchange_rate(params, resolution()) ::
          {:ok, exchange_rate()} | {:error, ErrorMessage.t()}
  def get_exchange_rate(%{from_currency: from_currency, to_currency: from_currency}, _) do
    {:error,
     ErrorMessage.bad_request("Please enter two different currencies!", %{
       from_currency: from_currency,
       to_currency: from_currency
     })}
  end

  def get_exchange_rate(%{from_currency: from_currency, to_currency: to_currency}, _) do
    with {:ok, exchange_rate} <-
           ExchangeRateStorage.get_exchange_rate(from_currency, to_currency, @exchange_rate_cache) do
      {:ok,
       %ExchangeRate{from_currency: from_currency, to_currency: to_currency, rate: exchange_rate}}
    end
  end
end
