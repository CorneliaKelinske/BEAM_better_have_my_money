defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.TotalWorthTest do
  use BEAMBetterHaveMyMoneyWeb.SubscriptionCase

  import BEAMBetterHaveMyMoney.AccountsFixtures,
    only: [user: 1, wallet: 1, user2: 1, user2_wallet: 1]

  @currency "CAD"

  @deposit_amount_doc """
  mutation DepositAmount($user_id: ID!, $currency: Currency!, $cent_amount: Int!) {
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

  @withdraw_amount_doc """
  mutation WithdrawAmount($user_id: ID!, $currency: Currency!, $cent_amount: Int!){
    withdrawAmount (user_id: $user_id, currency: $currency, cent_amount: $cent_amount) {
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

  @send_amount_doc """
  mutation SendAmount($from_user_id: ID!, $from_currency: Currency!, $cent_amount: Int!, $to_user_id: ID!, $to_currency: Currency!){
    sendAmount (from_user_id: $from_user_id, from_currency: $from_currency, cent_amount: $cent_amount
      to_user_id: $to_user_id, to_currency: $to_currency) {
        from_wallet {
          id
          user_id
          currency
          cent_amount
        },
        cent_amount
        from_currency
        to_currency
        exchange_rate
        to_wallet {
          id
          user_id
          currency
          cent_amount
        }
      }
  }
  """

  @total_worth_changed_doc """
  subscription TotalWorthChanged($userId: ID!) {
    totalWorthChanged(user_id: $userId) {
      user_id
      cent_amount
      currency
      transaction_type
    }
  }
  """

  describe "@total_worth_changed" do
    setup [:user, :wallet, :user2, :user2_wallet]

    test "sends the total worth change for the corresponding user when @totalWorthChanged mutation is triggered when an amount is deposited",
         %{socket: socket, user: %{id: id}} do
      user_id = to_string(id)

      ref = push_doc(socket, @total_worth_changed_doc, variables: %{"userId" => id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @deposit_amount_doc,
          variables: %{"user_id" => id, "currency" => @currency, "cent_amount" => 1_000}
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "depositAmount" => %{
                   "user_id" => ^user_id,
                   "currency" => @currency
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
                     "cent_amount" => 1_000,
                     "currency" => @currency,
                     "transaction_type" => "DEPOSIT"
                   }
                 }
               }
             } = data
    end

    test "sends the total worth change for the corresponding user when @totalWorthChanged mutation is triggered when an amount is withdrawn",
         %{socket: socket, user: %{id: id}} do
      user_id = to_string(id)

      ref = push_doc(socket, @total_worth_changed_doc, variables: %{"userId" => id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @withdraw_amount_doc,
          variables: %{"user_id" => id, "currency" => @currency, "cent_amount" => 1_000}
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "withdrawAmount" => %{
                   "user_id" => ^user_id,
                   "currency" => @currency
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
                     "cent_amount" => 1_000,
                     "currency" => @currency,
                     "transaction_type" => "WITHDRAWAL"
                   }
                 }
               }
             } = data
    end

    test "sends the total worth change for the sender when @totalWorthChanged mutation is triggered when an amount is sent",
         %{
           socket: socket,
           user: %{id: from_user_id},
           user2: %{id: to_user_id},
           wallet: %{cent_amount: from_wallet_cent_amount},
           user2_wallet: %{cent_amount: to_wallet_cent_amount}
         } do
      from_user_id = to_string(from_user_id)
      to_user_id = to_string(to_user_id)
      from_wallet_cent_amount = from_wallet_cent_amount - 1000
      to_wallet_cent_amount = to_wallet_cent_amount + 1000

      ref = push_doc(socket, @total_worth_changed_doc, variables: %{"userId" => from_user_id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @send_amount_doc,
          variables: %{
            "from_user_id" => from_user_id,
            "from_currency" => @currency,
            "cent_amount" => 1000,
            "to_user_id" => to_user_id,
            "to_currency" => @currency
          }
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "sendAmount" => %{
                   "cent_amount" => 1000,
                   "exchange_rate" => 1.0,
                   "from_currency" => @currency,
                   "from_wallet" => %{
                     "cent_amount" => ^from_wallet_cent_amount,
                     "currency" => @currency,
                     "user_id" => ^from_user_id
                   },
                   "to_currency" => @currency,
                   "to_wallet" => %{
                     "cent_amount" => ^to_wallet_cent_amount,
                     "currency" => @currency,
                     "user_id" => ^to_user_id
                   }
                 }
               }
             } = reply

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "totalWorthChanged" => %{
                     "user_id" => ^from_user_id,
                     "cent_amount" => 1_000,
                     "currency" => @currency,
                     "transaction_type" => "WITHDRAWAL"
                   }
                 }
               }
             } = data
    end

    test "sends the total worth change for the recipient when @totalWorthChanged mutation is triggered when an amount is sent",
         %{
           socket: socket,
           user: %{id: from_user_id},
           user2: %{id: to_user_id},
           wallet: %{cent_amount: from_wallet_cent_amount},
           user2_wallet: %{cent_amount: to_wallet_cent_amount}
         } do
      from_user_id = to_string(from_user_id)
      to_user_id = to_string(to_user_id)
      from_wallet_cent_amount = from_wallet_cent_amount - 1000
      to_wallet_cent_amount = to_wallet_cent_amount + 1000

      ref = push_doc(socket, @total_worth_changed_doc, variables: %{"userId" => to_user_id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @send_amount_doc,
          variables: %{
            "from_user_id" => from_user_id,
            "from_currency" => @currency,
            "cent_amount" => 1000,
            "to_user_id" => to_user_id,
            "to_currency" => @currency
          }
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "sendAmount" => %{
                   "cent_amount" => 1000,
                   "exchange_rate" => 1.0,
                   "from_currency" => @currency,
                   "from_wallet" => %{
                     "cent_amount" => ^from_wallet_cent_amount,
                     "currency" => @currency,
                     "user_id" => ^from_user_id
                   },
                   "to_currency" => @currency,
                   "to_wallet" => %{
                     "cent_amount" => ^to_wallet_cent_amount,
                     "currency" => @currency,
                     "user_id" => ^to_user_id
                   }
                 }
               }
             } = reply

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "totalWorthChanged" => %{
                     "user_id" => ^to_user_id,
                     "cent_amount" => 1_000,
                     "currency" => @currency,
                     "transaction_type" => "DEPOSIT"
                   }
                 }
               }
             } = data
    end
  end
end
