defmodule BEAMBetterHaveMyMoneyWeb.Types.User do
  @moduledoc false
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A user who can have one or more wallets"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)

    field :wallets, list_of(:wallet), resolve: dataloader(BEAMBetterHaveMyMoney.Accounts, :wallet)
  end
end
