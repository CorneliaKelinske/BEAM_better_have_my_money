defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.ExchangeRate do
  @moduledoc false
  use Absinthe.Schema.Notation

  object :exchange_rate_subscriptions do
    @desc "Broadcasts exchange rate updates"
    field :exchange_rate_updated, :exchange_rate do
      arg :currency, :currency

      config fn
        %{currency: currency}, _ ->

          {:ok, topic: "exchange rate updated:#{currency}"}

        _, _ ->

          {:ok, topic: "exchange rate updated:all"}
      end

      resolve fn exchange_rate, _args, _res -> {:ok, exchange_rate} end
    end
  end
end
