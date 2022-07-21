defmodule BEAMBetterHaveMyMoneyWeb.Schema.Mutations.WalletTest do
  use BEAMBetterHaveMyMoney.DataCase, async: true
  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, wallet: 1]
  alias BEAMBetterHaveMyMoneyWeb.Schema

  @create_wallet_doc """
    mutation CreateWallet($user_id: ID!, $currency: Currency!, $cent_amount: Int!){
    createWallet (user_id: $user_id, currency: $currency, cent_amount: $cent_amount) {
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

  describe "@create_wallet" do
    setup [:user]

    test "creates a new wallet for a user", %{user: %{id: id, name: name, email: email}} do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{
                   "createWallet" => %{
                     "user_id" => ^user_id,
                     "currency" => "CAD",
                     "cent_amount" => 100_000,
                     "user" => %{
                       "id" => ^user_id,
                       "name" => ^name,
                       "email" => ^email
                     }
                   }
                 }
               }
             } =
               Absinthe.run(@create_wallet_doc, Schema,
                 variables: %{"user_id" => id, "currency" => "CAD", "cent_amount" => 100_000}
               )
    end
  end

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

  describe "@deposit_amount" do
    setup [:user, :wallet]

    test "adds an amount to the wallet balance", %{
      user: %{id: id, name: name, email: email},
      wallet: %{currency: currency}
    } do
      user_id = to_string(id)
      currency = to_string(currency)

      assert {
               :ok,
               %{
                 data: %{
                   "depositAmount" => %{
                     "user_id" => ^user_id,
                     "currency" => ^currency,
                     "cent_amount" => 2_000,
                     "user" => %{
                       "id" => ^user_id,
                       "name" => ^name,
                       "email" => ^email
                     }
                   }
                 }
               }
             } =
               Absinthe.run(@deposit_amount_doc, Schema,
                 variables: %{"user_id" => id, "currency" => currency, "cent_amount" => 1_000}
               )
    end

    test "returns an error when a negative deposit amount is entered", %{
      wallet: %{user_id: id, currency: currency}
    } do
      currency = to_string(currency)

      assert {
               :ok,
               %{
                 data: %{"depositAmount" => nil},
                 errors: [
                   %{
                     code: :bad_request,
                     locations: [%{column: 3, line: 2}],
                     message: "Please enter a positive integer!",
                     path: ["depositAmount"]
                   }
                 ]
               }
             } =
               Absinthe.run(@deposit_amount_doc, Schema,
                 variables: %{"user_id" => id, "currency" => currency, "cent_amount" => -1_000}
               )
    end
  end

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

  describe "@withdraw_amount" do
    setup [:user, :wallet]

    test "deducts an amount from the wallet balance", %{
      user: %{id: id, name: name, email: email},
      wallet: %{currency: currency}
    } do
      user_id = to_string(id)
      currency = to_string(currency)

      assert {
               :ok,
               %{
                 data: %{
                   "withdrawAmount" => %{
                     "user_id" => ^user_id,
                     "currency" => ^currency,
                     "cent_amount" => 0,
                     "user" => %{
                       "id" => ^user_id,
                       "name" => ^name,
                       "email" => ^email
                     }
                   }
                 }
               }
             } =
               Absinthe.run(@withdraw_amount_doc, Schema,
                 variables: %{"user_id" => id, "currency" => currency, "cent_amount" => 1_000}
               )
    end

    test "returns an error when a negative withdrawal amount is entered", %{
      wallet: %{user_id: id, currency: currency}
    } do
      currency = to_string(currency)

      assert {
               :ok,
               %{
                 data: %{"withdrawAmount" => nil},
                 errors: [
                   %{
                     code: :bad_request,
                     locations: [%{column: 3, line: 2}],
                     message: "Please enter a positive integer!",
                     path: ["withdrawAmount"]
                   }
                 ]
               }
             } =
               Absinthe.run(@withdraw_amount_doc, Schema,
                 variables: %{"user_id" => id, "currency" => currency, "cent_amount" => -1_000}
               )
    end
  end
end
