defmodule BEAMBetterHaveMyMoneyWeb.Types.TotalWorth do
  @moduledoc false
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [batch: 3]
  import Ecto.Query

  alias BEAMBetterHaveMyMoney.{Accounts.User, Repo}

  @desc "The total worth of a user in a given currency"
  object :total_worth do
    field :cent_amount, non_null(:integer)
    field :currency, non_null(:currency)
    field :user_id, non_null(:id)

    field :user, :user do
      resolve fn total_worth, _, _ ->
        batch({__MODULE__, :users_by_id}, total_worth.user_id, fn batch_results ->
          {:ok, Map.get(batch_results, String.to_integer(total_worth.user_id))}
        end)
      end
    end
  end

  def users_by_id(_, user_ids) do
    users = Repo.all(from u in User, where: u.id in ^user_ids)
    Map.new(users, fn user -> {user.id, user} end)
  end
end
