defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.TotalWorth do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  object :total_worth_subscriptions do
    @desc "Broadcasts a change in a user's total worth"
    field :total_worth_changed, :wallet do
      arg :user_id, non_null(:id)

      config fn args, _ -> {:ok, topic: key(args)} end


      resolve fn wallet_id, _, _  -> Resolvers.Wallet.find(%{id: wallet_id + 1}, %{}) end

    end
  end

  defp key(%{user_id: user_id}) do
    "user_total_worth_change:#{user_id}"
  end
end