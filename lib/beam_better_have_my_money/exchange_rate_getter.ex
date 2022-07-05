defmodule BEAMBetterHaveMyMoney.ExchangeRateGetter do
  @moduledoc false

  def query_api_and_decode_json_response(from_currency, to_currency) do
    with {:ok, body} <- request_exchange_rate(from_currency, to_currency) do
      decode_json(body)
    end
  end

  defp request_exchange_rate(from_currency, to_currency) do
    case HTTPoison.get("localhost:4001/query", [],
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

  # defp api_key do
  #   Application.get_env(:beam_better_have_my_money, :api_key)
  # end
end
