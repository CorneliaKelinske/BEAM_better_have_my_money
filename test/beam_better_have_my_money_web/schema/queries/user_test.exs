defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.UserTest do
  use BEAMBetterHaveMyMoney.DataCase, async: true

  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, wallet: 1]

  alias BEAMBetterHaveMyMoneyWeb.Schema

  setup [:user, :wallet]

  @all_users_doc """
  query Users($name: String) {
    users (name: $name) {
      id
      name
      email
      wallets {
        id
        user_id
        currency
        cent_amount
      }
    }
  }
  """

  describe "@users" do
    test "fetches users by name", %{
      user: %{name: name, email: email, id: id}
    } do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{
                   "users" => [
                     %{
                       "id" => ^user_id,
                       "name" => ^name,
                       "email" => ^email,
                       "wallets" => [
                         %{
                           "user_id" => ^user_id
                         }
                       ]
                     }
                   ]
                 }
               }
             } = Absinthe.run(@all_users_doc, Schema, variables: %{"name" => name})
    end

    test "returns an empty when no user with the given name exists" do
      assert {:ok, %{data: %{"users" => []}}} =
               Absinthe.run(@all_users_doc, Schema, variables: %{"name" => "RANDOM NAME"})
    end
  end

  @find_user_doc """
  query User($id: ID, $email: String ) {
    user (id: $id, email: $email) {
      id
      name
      email
      wallets {
        id
        user_id
        currency
        cent_amount
      }
    }
  }
  """

  describe "@user" do
    test "fetches a user based on their email", %{user: %{name: name, email: email, id: id}} do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{
                   "user" => %{
                     "id" => ^user_id,
                     "name" => ^name,
                     "email" => ^email,
                     "wallets" => [
                       %{
                         "user_id" => ^user_id
                       }
                     ]
                   }
                 }
               }
             } = Absinthe.run(@find_user_doc, Schema, variables: %{"email" => email})
    end

    test "returns an error message when a user with the given email does not exist" do
      assert {:ok,
              %{
                data: %{"user" => nil},
                errors: [
                  %{
                    code: :not_found,
                    locations: [%{column: 3, line: 2}],
                    message: "no records found",
                    path: ["user"]
                  }
                ]
              }} = Absinthe.run(@find_user_doc, Schema, variables: %{"email" => "RandomEmail"})
    end
  end
end
