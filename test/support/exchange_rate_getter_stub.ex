defmodule BEAMBetterHaveMyMoney.ExchangeRateGetterStub do
  @moduledoc """
  Is called in tests instead of the Exchange Rate Getter and returns
  a fixed set of data for further processing
  """
  alias BEAMBetterHaveMyMoney.Accounts.Wallet

  @type currency :: Wallet.currency()

  @spec query_api_and_decode_json_response(currency, currency) ::
          {:ok, %{optional(String.t()) => :atom | String.t()}}
  def query_api_and_decode_json_response(from_currency, to_currency) do
    {:ok,
     %{
       "1. From_Currency Code" => from_currency,
       "3. To_Currency Code" => to_currency,
       "5. Exchange Rate" => "1.11"
     }}
  end
end
