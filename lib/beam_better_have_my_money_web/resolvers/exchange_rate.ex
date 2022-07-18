defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.ExchangeRate do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts.Wallet, Config}
  alias BEAMBetterHaveMyMoney.{Exchanger.ExchangeRate, ExchangeRateStorage}

  @exchange_rate_cache Config.exchange_rate_cache()

  @type resolution :: Absinthe.Resolution.t()
  @type error :: BEAMBetterHaveMyMoney.Accounts.error()
  @type currency :: Wallet.currency()
  @type exchange_rate :: ExchangeRate.t()

  @spec get_exchange_rate(%{from_currency: currency(), to_currency: currency()}, resolution()) ::
          {:ok, exchange_rate()} | {:error, error}
  def get_exchange_rate(%{from_currency: from_currency, to_currency: from_currency}, _) do
    {:ok, %{from_currency: from_currency, to_currency: from_currency, rate: 1.00}}
  end

  def get_exchange_rate(%{from_currency: from_currency, to_currency: to_currency}, _) do
    case ExchangeRateStorage.get_exchange_rate(from_currency, to_currency, @exchange_rate_cache) do
      nil ->
        {:error,
         %ErrorMessage{
           message: "Exchange rate currently not available. Please try again!",
           code: :not_found
         }}

      rate ->
        {:ok, %ExchangeRate{from_currency: from_currency, to_currency: to_currency, rate: rate}}
    end
  end
end
