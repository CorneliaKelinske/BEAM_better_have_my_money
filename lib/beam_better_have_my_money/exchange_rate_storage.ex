defmodule BEAMBetterHaveMyMoney.ExchangeRateStorage do
  @moduledoc """
  Uses ETS to store the exchange rates for each currency combination
  retrieved by the Exchanger module
  """

  alias BEAMBetterHaveMyMoney.Exchanger.ExchangeRate

  @spec store_exchange_rate(ExchangeRate.t()) :: :ok
  def store_exchange_rate(%ExchangeRate{
        from_currency: from_currency,
        to_currency: to_currency,
        rate: rate
      }) do
    ConCache.put(:exchange_rate_cache, key(from_currency, to_currency), rate)
  end

  @spec get_exchange_rate(String.t(), String.t()) :: String.t()
  def get_exchange_rate(from_currency, to_currency) do
    ConCache.get(:exchange_rate_cache, key(from_currency, to_currency))
  end

  defp key(from_currency, to_currency) do
    "#{from_currency} to #{to_currency}"
  end
end
