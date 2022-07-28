defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.ExchangeRateTest do
  use BEAMBetterHaveMyMoney.DataCase

  alias BEAMBetterHaveMyMoney.{Exchanger.ExchangeRate, ExchangeRateStorage}
  alias BEAMBetterHaveMyMoneyWeb.Schema

  setup do
    start_supervised!({ConCache, name: :test_cache, ttl_check_interval: 20, global_ttl: 3_000})

    ExchangeRateStorage.store_exchange_rate(
      %ExchangeRate{from_currency: :CAD, to_currency: :USD, rate: 1.00},
      :test_cache
    )

    :ok
  end

  @get_exchange_rate_doc """
  query ExchangeRate($from_currency: Currency!, $to_currency: Currency!) {
    exchangeRate (from_currency: $from_currency, to_currency: $to_currency) {
      from_currency
      to_currency
      rate
    }
  }
  """

  describe "@exchange_rate" do
    test "fetches an exchange rate for the two given currencies" do
      assert {:ok,
              %{
                data: %{
                  "exchangeRate" => %{
                    "from_currency" => "CAD",
                    "rate" => 1.0,
                    "to_currency" => "USD"
                  }
                }
              }} =
               Absinthe.run(@get_exchange_rate_doc, Schema,
                 variables: %{"from_currency" => "CAD", "to_currency" => "USD"}
               )
    end
  end
end
