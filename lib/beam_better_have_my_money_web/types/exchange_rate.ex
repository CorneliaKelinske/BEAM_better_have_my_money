defmodule BEAMBetterHaveMyMoneyWeb.Types.ExchangeRate do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "The exchange rate between two given currencies"
  object :exchange_rate do
    field :from_currency, non_null(:currency)
    field :to_currency, non_null(:currency)
    field :rate, non_null(:float)
  end

end
