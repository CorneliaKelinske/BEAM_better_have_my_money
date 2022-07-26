defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.ExchangeRate do
  @moduledoc false
  use Absinthe.Schema.Notation

  object :exchange_rate_subscriptions do
    @desc "Broadcasts exchange rate updates for all currencies"
    field :exchange_rate_updated, :exchange_rate do

      config fn _, _ -> {:ok, topic: "exchange rate update"} end
    end

    @desc "Broadcasts exchange rate updates for a specific currency pair"
    field :specific_exchange_rate_updated, :exchange_rate do
      arg :from_currency, non_null(:currency)
      arg :to_currency, non_null(:currency)

      config fn args, _ -> {:ok, topic: key(args)} end

    end
  end

  defp key(%{from_currency: from_currency, to_currency: to_currency}) do
    "specific_exchange_rate_updated: from #{from_currency} to #{to_currency}"
  end
end
