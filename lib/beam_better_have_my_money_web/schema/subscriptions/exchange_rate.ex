defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.ExchangeRate do
  @moduledoc false
  use Absinthe.Schema.Notation

  object :exchange_rate_subscriptions do
    @desc "Broadcasts exchange rate updates"
    field :exchange_rate_updated, :exchange_rate do
      arg :currency, :currency

      config fn
        %{currency: currency}, _ ->
          {:ok, topic: "exchange_rate_updated:#{currency}"}

        _, _ ->
          {:ok, topic: "exchange_rate_updated:all"}
      end
    end
  end
end
