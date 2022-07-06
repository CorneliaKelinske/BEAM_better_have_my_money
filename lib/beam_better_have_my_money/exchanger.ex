defmodule BEAMBetterHaveMyMoney.Exchanger do
  @moduledoc """
  Returns the exchange rate for the
  entered currencies
  """

  alias BEAMBetterHaveMyMoney.Exchanger.{ExchangeRate, ExchangeRateGetter}

  @currencies ["CAD", "USD", "EUR"]

  def run_query() do
  for currency1 <- @currencies,
      currency2 <- @currencies,
      currency2 != currency1 do
        exchange_rate(currency1, currency2)
      end

  end
  @spec exchange_rate(String.t(), String.t()) :: {:ok, ExchangeRate.t()} | {:error, ExchangeRateGetter.error()}
  def exchange_rate(from_currency, to_currency) do
    with {:ok, data} <- ExchangeRateGetter.query_api_and_decode_json_response(from_currency, to_currency) do
      exchange_rate = ExchangeRate.new(data)
      {:ok, exchange_rate}
    end
  end

  
end
