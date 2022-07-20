defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.ExchangeRate do
  @moduledoc false

  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  object :exchange_rate_queries do
    @desc "Fetches the exchange rate for two given currencies"
    field :exchange_rate, :exchange_rate do
      arg :from_currency, non_null(:currency)
      arg :to_currency, non_null(:currency)

      resolve &Resolvers.ExchangeRate.get_exchange_rate/2
    end
  end
end
