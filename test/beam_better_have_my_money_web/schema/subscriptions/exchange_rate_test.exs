defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.ExchangeRateTest do
  use BEAMBetterHaveMyMoneyWeb.SubscriptionCase

  alias BEAMBetterHaveMyMoney.Config

  @currencies Enum.map(Config.currencies(), &to_string(&1))

  @exchange_rate_updated_doc """
  subscription ExchangeRateUpdated{
    exchangeRateUpdated{
      from_currency
      to_currency
      rate
    }
  }
  """

  describe "@exchange_rate_updated" do
    test "broadcasts the updates for all exchange rate pairs", %{socket: socket} do
      ref = push_doc(socket, @exchange_rate_updated_doc, variables: %{})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      assert_push("subscription:data", data, 10_000)

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "exchangeRateUpdated" => %{
                     "from_currency" => from_currency,
                     "to_currency" => to_currency,
                     "rate" => 1.11
                   }
                 }
               }
             } = data

      assert from_currency in @currencies
      assert to_currency in @currencies
    end

    @specific_rate_updated_doc """
    subscription ExchangeRateUpdated($currency: Currency) {
      exchangeRateUpdated(currency: $currency) {
        from_currency
        to_currency
        rate
      }
    }
    """

    test "broadcasts only updates for a specific exchange rate", %{socket: socket} do
      ref = push_doc(socket, @specific_rate_updated_doc, variables: %{"currency" => "USD"})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      assert_push("subscription:data", data, 10_000)

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "exchangeRateUpdated" => %{
                     "from_currency" => "USD",
                     "to_currency" => to_currency,
                     "rate" => 1.11
                   }
                 }
               }
             } = data

      assert to_currency in @currencies
    end
  end
end
