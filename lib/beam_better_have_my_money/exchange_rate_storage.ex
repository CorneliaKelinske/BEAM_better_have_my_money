defmodule BEAMBetterHaveMyMoney.ExchangeRateStorage do
  @moduledoc """
  Uses ETS to store the exchange rates for each currency combination
  retrieved by the Exchanger module
  """

  alias BEAMBetterHaveMyMoney.Exchanger.ExchangeRate

  @name :exchange_rate_cache

  @spec store_exchange_rate(ExchangeRate.t()) :: :ok
  def store_exchange_rate(%ExchangeRate{
        from_currency: from_currency,
        to_currency: to_currency,
        rate: rate
      }, name \\ @name) do
    ConCache.put(name, key(from_currency, to_currency), rate) |> IO.inspect(label: "#{from_currency}", limit: :infinity, charlists: false)
  end

  @spec get_exchange_rate(String.t(), String.t()) :: String.t()
  def get_exchange_rate(from_currency, to_currency, name \\ @name) do
    ConCache.get(name, key(from_currency, to_currency)) |> IO.inspect(label: "Retrieving #{from_currency}", limit: :infinity, charlists: false)
  end

  defp key(from_currency, to_currency) do
    "#{from_currency} to #{to_currency}"
  end
end
