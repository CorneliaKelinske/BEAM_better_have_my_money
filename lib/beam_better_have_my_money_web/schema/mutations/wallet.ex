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

    @desc "Adds a given amount to a wallet"
    field :deposit_amount, :wallet do
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)
      arg :cent_amount, non_null(:integer)

      resolve &Resolvers.Wallet.deposit_amount/2
    end

    @desc "Deducts a given amount from a wallet"
    field :withdraw_amount, :wallet do
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)
      arg :cent_amount, non_null(:integer)

      resolve &Resolvers.Wallet.withdraw_amount/2
    end
  end
end
