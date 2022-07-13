defmodule BEAMBetterHaveMyMoneyWeb.Types.Wallet do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A user's wallet for a specific currency"
  object :wallet do
    field :id, non_null(:id)
    field :currency, non_null(:currency)
    field :cent_amount, non_null(:integer)
    field :user_id, non_null(:id)
    field :user, :user, resolve: dataloader(BEAMBetterHaveMyMoney.Accounts, :user)

  end
end
