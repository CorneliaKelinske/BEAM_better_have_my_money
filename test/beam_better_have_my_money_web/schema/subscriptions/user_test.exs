defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.UserTest do
  use BEAMBetterHaveMyMoneyWeb.SubscriptionCase

  @create_user_doc """
   mutation CreateUser($name: String!, $email: String!){
   createUser (name: $name, email: $email) {
    id
    name
    email
   }
  }
  """

  @created_user_doc """
  subscription CreatedUser {
   createdUser {
     id
     name
     email
   }
  }
  """

  describe "@created_user" do
    test "sends a user when @createdUser mutation is triggered", %{socket: socket} do
      ref = push_doc(socket, @created_user_doc, variables: %{})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @create_user_doc,
          variables: %{
            "name" => "Waldo",
            "email" => "butters@example.com"
          }
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "createUser" => %{
                   "name" => "Waldo",
                   "email" => "butters@example.com"
                 }
               }
             } = reply

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "createdUser" => %{
                     "name" => "Waldo",
                     "email" => "butters@example.com"
                   }
                 }
               }
             } = data
    end
  end
end
