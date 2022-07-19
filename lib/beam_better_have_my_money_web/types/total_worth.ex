defmodule BEAMBetterHaveMyMoneyWeb.Types.TotalWorth do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  @desc "The total worth of a user in a given currency"
  object :total_worth do
    field :cent_amount, non_null(:integer)
    field :currency, non_null(:currency)
    field :user_id, non_null(:id)

    field :user, non_null(:user), resolve: &Resolvers.User.find/3
  end
end
