defmodule BEAMBetterHaveMyMoneyWeb.Schema.Mutations.WalletTest do
  use BEAMBetterHaveMyMoney.DataCase, async: true

  import BEAMBetterHaveMyMoney.AccountsFixtures,
    only: [user: 1, wallet: 1, user2: 1, user2_wallet: 1]

  alias BEAMBetterHaveMyMoneyWeb.Schema

  @currency "CAD"

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
                     "currency" => @currency,
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
                 variables: %{"user_id" => id, "currency" => @currency, "cent_amount" => 100_000}
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

  describe "@send_amount" do
    setup [:user, :wallet, :user2, :user2_wallet]

    test "sends an amount from one wallet to another", %{
      user: %{id: from_user_id},
      user2: %{id: to_user_id},
      wallet: %{cent_amount: from_wallet_cent_amount},
      user2_wallet: %{cent_amount: to_wallet_cent_amount}
    } do
      from_wallet_cent_amount = from_wallet_cent_amount - 1000
      to_wallet_cent_amount = to_wallet_cent_amount + 1000
      string_from_user_id = to_string(from_user_id)
      string_to_user_id = to_string(to_user_id)

      assert {:ok,
              %{
                data: %{
                  "sendAmount" => %{
                    "cent_amount" => 1000,
                    "exchange_rate" => 1.0,
                    "from_currency" => @currency,
                    "from_wallet" => %{
                      "cent_amount" => ^from_wallet_cent_amount,
                      "currency" => @currency,
                      "user_id" => ^string_from_user_id
                    },
                    "to_currency" => @currency,
                    "to_wallet" => %{
                      "cent_amount" => ^to_wallet_cent_amount,
                      "currency" => @currency,
                      "user_id" => ^string_to_user_id
                    }
                  }
                }
              }} =
               Absinthe.run(@send_amount_doc, Schema,
                 variables: %{
                   "from_user_id" => from_user_id,
                   "from_currency" => @currency,
                   "cent_amount" => 1000,
                   "to_user_id" => to_user_id,
                   "to_currency" => @currency
                 }
               )
    end

    test "returns a meaningful error message when the transaction does not succeed", %{
      user: %{id: from_user_id},
      user2: %{id: to_user_id}
    } do
      assert {
               :ok,
               %{
                 data: %{"sendAmount" => nil},
                 errors: [
                   %{
                     code: :not_found,
                     message: "One of the wallets was not found",
                     name: :check_wallets_found,
                     path: ["sendAmount"]
                   }
                 ]
               }
             } =
               Absinthe.run(@send_amount_doc, Schema,
                 variables: %{
                   "from_user_id" => from_user_id,
                   "from_currency" => @currency,
                   "cent_amount" => 1000,
                   "to_user_id" => to_user_id + 1,
                   "to_currency" => @currency
                 }
               )
    end

    test "returns an error when a negative transfer amount is entered", %{
      user: %{id: from_user_id},
      user2: %{id: to_user_id}
    } do
      assert {
               :ok,
               %{
                 data: %{"sendAmount" => nil},
                 errors: [
                   %{
                     code: :bad_request,
                     message: "Please enter a positive integer!",
                     path: ["sendAmount"]
                   }
                 ]
               }
             } =
               Absinthe.run(@send_amount_doc, Schema,
                 variables: %{
                   "from_user_id" => from_user_id,
                   "from_currency" => @currency,
                   "cent_amount" => -1000,
                   "to_user_id" => to_user_id + 1,
                   "to_currency" => @currency
                 }
               )
    end
  end
end
