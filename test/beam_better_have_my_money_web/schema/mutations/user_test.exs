defmodule BEAMBetterHaveMyMoneyWeb.Schema.Mutations.UserTest do
  use BEAMBetterHaveMyMoney.DataCase, async: true
  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1]
  alias BEAMBetterHaveMyMoney.Accounts
  alias BEAMBetterHaveMyMoneyWeb.Schema

  @create_user_doc """
    mutation CreateUser($name: String!, $email: String!){
    createUser (name: $name, email: $email) {
     id
     name
     email
    }
  }
  """

  describe "@create_user" do
    test "creates a new user" do
      assert {
               :ok,
               %{
                 data: %{
                   "createUser" => %{
                     "name" => "Molly",
                     "email" => "molly@example.com"
                   }
                 }
               }
             } =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{
                   "name" => "Molly",
                   "email" => "molly@example.com"
                 }
               )

      assert {:ok, %{name: "Molly"}} = Accounts.find_user(%{email: "molly@example.com"})
    end
  end

  @update_user_doc """
    mutation UpdateUser($id: ID!, $name: String!, $email: String!){
    updateUser (id: $id, name: $name, email: $email) {
    id
    name
    email
    }
  }
  """

  describe "@update_user" do
    setup :user

    test "updates a user based on their id", %{user: %{id: id}} do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{
                   "updateUser" => %{
                     "name" => "Horst",
                     "email" => "horst@example.com",
                     "id" => ^user_id
                   }
                 }
               }
             } =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{"id" => user_id, "name" => "Horst", "email" => "horst@example.com"}
               )

      assert {:ok, %{name: "Horst"}} = Accounts.find_user(%{id: id})
    end
  end
end
