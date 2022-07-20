defmodule BEAMBetterHaveMyMoney.ExchangeRateStorage do
  @moduledoc """
  Uses ETS to store the exchange rates for each currency combination
  retrieved by the Exchanger module
  """

  alias BEAMBetterHaveMyMoney.Accounts.Wallet
  alias BEAMBetterHaveMyMoney.Exchanger.ExchangeRate

  @type currency :: Wallet.currency()
  @name :exchange_rate_cache

  @spec store_exchange_rate(ExchangeRate.t(), atom) :: :ok
  def store_exchange_rate(
        %ExchangeRate{
          from_currency: from_currency,
          to_currency: to_currency,
          rate: rate
        },
        name \\ @name
      ) do
    ConCache.put(name, key(from_currency, to_currency), rate)
  end

  @spec get_exchange_rate(currency(), currency(), atom) ::
          {:ok, float()} | {:error, ErrorMessage.t()}
  def get_exchange_rate(from_currency, to_currency, name \\ @name) do
    case ConCache.get(name, key(from_currency, to_currency)) do
      nil ->
        {:error,
         ErrorMessage.not_found("Exchange rate currently not available. Please try again!", %{
           from_currency: from_currency,
           to_currency: to_currency
         })}

      float ->
        {:ok, float}
    end
  end

  defp key(from_currency, to_currency) do
    "#{from_currency} to #{to_currency}"
  end
end
