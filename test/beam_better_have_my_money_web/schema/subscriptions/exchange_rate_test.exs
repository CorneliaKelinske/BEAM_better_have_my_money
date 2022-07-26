defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.ExchangeRateTest do
  use BEAMBetterHaveMyMoneyWeb.SubscriptionCase

  alias BEAMBetterHaveMyMoney.Exchanger

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

      assert nil = data
    end
  end
end
