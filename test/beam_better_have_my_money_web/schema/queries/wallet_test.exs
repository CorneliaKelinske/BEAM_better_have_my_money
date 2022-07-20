defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.WalletTest do
  use BEAMBetterHaveMyMoney.DataCase, async: true

  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, wallet: 1, wallet2: 1]

  alias BEAMBetterHaveMyMoneyWeb.Schema

  setup [:user, :wallet, :wallet2]

  @all_wallets_doc """
  query Wallets($currency: Currency, $user_id: ID) {
    wallets (currency: $currency, user_id: $user_id) {
      id
      currency
      cent_amount
      user_id
      user {
        id
        name
        email
      }
    }
  }
  """

  describe "@wallets" do
    test "fetches wallets by user_id", %{
      user: %{name: name, email: email, id: id},
      wallet: %{user_id: id, currency: currency, cent_amount: cent_amount},
      wallet2: %{user_id: id, currency: currency2, cent_amount: cent_amount2}
    } do
      user_id = to_string(id)
      currency = to_string(currency)
      currency2 = to_string(currency2)

      assert {
               :ok,
               %{
                 data: %{
                   "wallets" => [
                     %{
                       "user_id" => ^user_id,
                       "currency" => ^currency,
                       "cent_amount" => ^cent_amount,
                       "user" => %{
                         "id" => ^user_id,
                         "name" => ^name,
                         "email" => ^email
                       }
                     },
                     %{
                       "user_id" => ^user_id,
                       "currency" => ^currency2,
                       "cent_amount" => ^cent_amount2,
                       "user" => %{
                         "id" => ^user_id,
                         "name" => ^name,
                         "email" => ^email
                       }
                     }
                   ]
                 }
               }
             } = Absinthe.run(@all_wallets_doc, Schema, variables: %{"user_id" => id})
    end

    test "returns an empty list when a wallet with the given user_id does not exist", %{
      user: %{id: id}
    } do
      user_id = id + 2

      assert {:ok, %{data: %{"wallets" => []}}} =
               Absinthe.run(@all_wallets_doc, Schema, variables: %{"user_id" => user_id})
    end
  end

  @find_wallet_doc """
  query Wallet($id: ID, $user_id: ID, $currency: Currency){
    wallet (id: $id, user_id: $user_id, currency: $currency) {
      id
      currency
      cent_amount
      user_id
      user {
        id
        name
        email
      }
    }
  }
  """

  describe "@wallet" do
    test "fetches a wallet based on it's id", %{
      user: %{name: name, email: email, id: user_id},
      wallet: %{id: id, user_id: user_id, currency: currency, cent_amount: cent_amount}
    } do
      user_id = to_string(user_id)
      id = to_string(id)
      currency = to_string(currency)

      assert {
               :ok,
               %{
                 data: %{
                   "wallet" => %{
                     "id" => ^id,
                     "user_id" => ^user_id,
                     "currency" => ^currency,
                     "cent_amount" => ^cent_amount,
                     "user" => %{
                       "id" => ^user_id,
                       "name" => ^name,
                       "email" => ^email
                     }
                   }
                 }
               }
             } = Absinthe.run(@find_wallet_doc, Schema, variables: %{"id" => id})
    end

    test "fetches a wallet based on it's user_id and currency", %{
      user: %{name: name, email: email, id: user_id},
      wallet: %{id: id, user_id: user_id, currency: currency, cent_amount: cent_amount}
    } do
      string_user_id = to_string(user_id)
      id = to_string(id)
      currency = to_string(currency)

      assert {
               :ok,
               %{
                 data: %{
                   "wallet" => %{
                     "id" => ^id,
                     "user_id" => ^string_user_id,
                     "currency" => ^currency,
                     "cent_amount" => ^cent_amount,
                     "user" => %{
                       "id" => ^string_user_id,
                       "name" => ^name,
                       "email" => ^email
                     }
                   }
                 }
               }
             } =
               Absinthe.run(@find_wallet_doc, Schema,
                 variables: %{"user_id" => user_id, "currency" => currency}
               )
    end

    test "returns an error if only user_id is passed in as an argument", %{
      wallet: %{user_id: user_id}
    } do
      assert {:ok,
              %{
                data: %{"wallet" => nil},
                errors: [
                  %{
                    code: :bad_request,
                    locations: [%{column: 3, line: 2}],
                    message: "Please search either by id or by user_id and currency",
                    path: ["wallet"]
                  }
                ]
              }} = Absinthe.run(@find_wallet_doc, Schema, variables: %{"user_id" => user_id})
    end
  end
end
