defmodule BEAMBetterHaveMyMoneyWeb.Schema.Mutations.WalletTest do
  use BEAMBetterHaveMyMoney.DataCase, async: true
  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1]
  alias BEAMBetterHaveMyMoney.Accounts
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
end
