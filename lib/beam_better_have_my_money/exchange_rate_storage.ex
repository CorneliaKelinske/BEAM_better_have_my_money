defmodule BEAMBetterHaveMyMoney.ExchangeRateStorage do
  @moduledoc """
  Uses ETS to store the exchange rates for each currency combination
  retrieved by the Exchanger module
  """

  def store_exchange_rate(from_currency, to_currency, exchange_rate) do
    ConCache.put(:exchange_rate_cache, key(from_currency, to_currency), exchange_rate)
  end

  def get_exchange_rate(from_currency, to_currency) do
    ConCache.get(:exchange_rate_cache, key(from_currency, to_currency))
  end

  def key(from_currency, to_currency) do
    "#{from_currency} to #{to_currency}"
  end

end
