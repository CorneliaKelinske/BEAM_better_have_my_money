defmodule BEAMBetterHaveMyMoneyWeb.Types.Transaction do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "A transaction where money is transferred between two wallets"
  object :transaction do
    field :from_wallet, non_null(:wallet)
    field :cent_amount, non_null(:integer)
    field :currency, non_null(:currency)
    field :to_wallet, non_null(:wallet)
  end
end
