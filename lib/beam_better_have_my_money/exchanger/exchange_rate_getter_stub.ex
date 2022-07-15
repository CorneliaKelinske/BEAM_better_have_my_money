defmodule BEAMBetterHaveMyMoney.Exchanger.ExchangeRateGetterStub do
  @moduledoc """
  Is called in tests instead of the Exchange Rate Getter and returns
  a fixed set of data for further processing
  """

  @spec query_api_and_decode_json_response(String.t(), String.t()) ::
          {:ok, %{optional(String.t()) => any}}
  def query_api_and_decode_json_response(from_currency, to_currency) do
    {:ok,
     %{
       "1. From_Currency Code" => from_currency,
       "3. To_Currency Code" => to_currency,
       "5. Exchange Rate" => "1.11"
     }} 
  end
end
