defmodule BEAMBetterHaveMyMoneyWeb.Schema.Queries.Wallet do
  @moduledoc false

  use Absinthe.Schema.Notation
  alias BEAMBetterHaveMyMoneyWeb.Resolvers

  object :wallet_queries do
    @desc "Returns a list of all wallets filtered based on the given parameters"
    field :wallets, list_of(:wallet) do
      arg :currency, :currency
      arg :user_id, :id

      resolve &Resolvers.Wallet.all/2
    end

    @desc "Returns a wallet based either on its id or its user_id and currency"
    field :wallet, :wallet do
      arg :id, :id
      arg :currency, :currency
      arg :user_id, :id

      resolve &Resolvers.Wallet.find/2
    end
  end
end
