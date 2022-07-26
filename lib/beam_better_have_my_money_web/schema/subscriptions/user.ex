defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.User do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  object :user_subscriptions do
    @desc "Broadcasts newly created user"
    field :created_user, :user do
      config fn _map, _resolution ->
        {:ok, topic: "new user"}
      end

      trigger :create_user, topic: fn _ -> "new user" end


      resolve fn user, _, _  -> Resolvers.User.find(%{id: user.id}, %{}) end


    end
  end
end
