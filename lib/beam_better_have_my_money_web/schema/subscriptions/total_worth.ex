defmodule BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.TotalWorth do
  @moduledoc false
  use Absinthe.Schema.Notation

  object :total_worth_subscriptions do
    @desc "Broadcasts a change in a user's total worth"
    field :total_worth_changed, :total_worth_change do
      arg :user_id, non_null(:id)

      config fn args, _ -> {:ok, topic: key(args)} end
    end
  end

  defp key(%{user_id: user_id}) do
    "user_total_worth_change:#{user_id}"
  end
end
