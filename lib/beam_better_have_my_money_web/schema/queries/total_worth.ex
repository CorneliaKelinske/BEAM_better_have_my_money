defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.TotalWorth do
  @moduledoc false

  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  object :total_worth_queries do
    @desc "Returns the total worth of a user in the given currency"
    field :total_worth, :total_worth do
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)

      resolve &Resolvers.TotalWorth.get_total_worth/2
    end
  end
end
