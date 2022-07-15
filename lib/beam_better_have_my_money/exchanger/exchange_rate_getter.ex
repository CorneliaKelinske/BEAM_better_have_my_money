defmodule BEAMBetterHaveMyMoney.Exchanger.ExchangeRateGetter do
  @moduledoc false

  alias BEAMBetterHaveMyMoney.Accounts.Wallet
  alias BEAMBetterHaveMyMoney.Config

  @exchange_rate_server Config.exchange_rate_server()

  @type currency :: Wallet.currency()
  @type error :: :not_decoded | String.t()

  @spec query_api_and_decode_json_response(currency(), currency()) ::
          {:ok, map} | {:error, error()}
  def query_api_and_decode_json_response(from_currency, to_currency) do
    with {:ok, body} <- request_exchange_rate(from_currency, to_currency) do
      decode_json(body)
    end
  end

  defp request_exchange_rate(from_currency, to_currency) do
    case HTTPoison.get(@exchange_rate_server, [],
           params: [
             function: "CURRENCY_EXCHANGE_RATE",
             from_currency: from_currency,
             to_currency: to_currency
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      error -> {:error, inspect(error)}
    end
  end

  defp decode_json(body) do
    case Jason.decode(body) do
      {:ok, %{"Realtime Currency Exchange Rate" => data}} -> {:ok, data}
      _ -> {:error, :not_decoded}
    end
  end
end
