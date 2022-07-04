defmodule BeamBetterHaveMyMoney.ExchangeRateGetter do
  @moduledoc false

  def request_exchange_rate() do
    HTTPoison.get("localhost:4001/query", [],
      params: [
        function: "CURRENCY_EXCHANGE_RATE",
        from_currency: "CAD",
        to_currency: "EUR"

      ]
    )
  end

  # defp api_key do
  #   Application.get_env(:beam_better_have_my_money, :api_key)
  # end
end
