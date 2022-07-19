defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.TotalWorthTest do
  use BEAMBetterHaveMyMoney.DataCase

  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, user2: 1, wallet: 1, wallet2: 1]

  alias BEAMBetterHaveMyMoney.{Exchanger.ExchangeRate, ExchangeRateStorage}
  alias BEAMBetterHaveMyMoneyWeb.Schema

  setup [:user, :user2, :wallet, :wallet2]

  @get_total_worth_doc """
  query TotalWorth($user_id: ID!, $currency: Currency!) {
    totalWorth (user_id: $user_id, currency: $currency) {
      cent_amount
      currency
      user_id
      user {
        id
        name
        email
      }
    }
  }
  """

  describe "@totalWorth" do
    setup do
      start_supervised!(
        {ConCache, name: :test_cache, ttl_check_interval: 20, global_ttl: 100_000}
      )

      ExchangeRateStorage.store_exchange_rate(
        %ExchangeRate{from_currency: :CAD, to_currency: :USD, rate: 2.00},
        :test_cache
      )

      :ok
    end

    test "fetches the total worth of a user in the given currency", %{
      user: %{id: id, name: name, email: email},
      wallet: %{cent_amount: cent_amount},
      wallet2: %{cent_amount: cent_amount2, currency: currency2}
    } do
      currency2 = to_string(currency2)
      user_id = to_string(id)
      net_worth = cent_amount * 2 + cent_amount2


      assert {:ok,
              %{
                data: %{
                  "totalWorth" => %{
                    "cent_amount" => ^net_worth,
                    "currency" => ^currency2,
                    "user" => %{
                      "email" => ^email,
                      "id" => ^user_id,
                      "name" => ^name
                    },
                    "user_id" => ^user_id
                  }
                }
              }} =
               Absinthe.run(@get_total_worth_doc, Schema,
                 variables: %{"user_id" => id, "currency" => currency2}
               )
    end

    test "returns error with error message when an exchange rate is not available", %{
      user: %{id: id}
    } do
      assert {:ok,
              %{
                data: %{"totalWorth" => nil},
                errors: [
                  %{
                    code: :not_found,
                    locations: [%{column: 3, line: 2}],
                    message: "Exchange rate currently not available. Please try again!",
                    path: ["totalWorth"]
                  }
                ]
              }} =
               Absinthe.run(@get_total_worth_doc, Schema,
                 variables: %{"user_id" => id, "currency" => "EUR"}
               )
    end

    test "returns error with error message when no wallets are found for the given user_id", %{
      user2: %{id: id}
    } do
      assert {:ok,
              %{
                data: %{"totalWorth" => nil},
                errors: [
                  %{
                    code: :not_found,
                    locations: [%{column: 3, line: 2}],
                    message: "No wallets found for this User Id.",
                    path: ["totalWorth"]
                  }
                ]
              }} =
               Absinthe.run(@get_total_worth_doc, Schema,
                 variables: %{"user_id" => id, "currency" => "CAD"}
               )
    end
  end
end
