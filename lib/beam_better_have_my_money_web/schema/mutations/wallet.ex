defmodule BEAMBetterHaveMyMoneyWeb.Schema.Mutations.Wallet do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  object :wallet_mutations do
    @desc "Creates a wallet belonging to a user"
    field :create_wallet, :wallet do
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)
      arg :cent_amount, non_null(:integer)

      resolve &Resolvers.Wallet.create_wallet/2
    end
  end
end
