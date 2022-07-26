defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.TotalWorthTest do
  use BEAMBetterHaveMyMoneyWeb.SubscriptionCase
  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, wallet: 1]

  @deposit_amount_doc """
    mutation DepositAmount($user_id: ID!, $currency: Currency!, $cent_amount: Int!){
    depositAmount (user_id: $user_id, currency: $currency, cent_amount: $cent_amount) {
    id
    user_id
    currency
    cent_amount
    user {
      id
      email
      name
      }
    }
  }
  """

  @total_worth_changed_doc """
  subscription TotalWorthChanged($userId: ID!) {
   totalWorthChanged(user_id: $userId) {
     id
     user_id
     currency
     cent_amount
   }
  }
  """

  describe "@total_worth_changed" do
    setup [:user, :wallet]

    test "sends a wallet when @totalWorthChanged mutation is triggered when an amount is deposited", %{socket: socket, user: %{id: id}} do
      user_id = to_string(id)

      ref = push_doc(socket, @total_worth_changed_doc, variables: %{"userId" => id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @deposit_amount_doc,
          variables: %{"user_id" => id, "currency" => "CAD", "cent_amount" => 1_000}
        )

      assert_reply ref, :ok, reply

      assert %{
        data: %{
          "depositAmount" => %{
            "user_id" => ^user_id,
            "currency" => "CAD"
          }
        }
      } = reply

      assert_push "subscription:data", data

      assert %{
        subscriptionId: ^subscription_id,
        result: %{
          data: %{
            "totalWorthChanged" => %{
              "user_id" => ^user_id,
              "currency" => "CAD"
            }
          }
        }
      } = data

    end

  end

end
