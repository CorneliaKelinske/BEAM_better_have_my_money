defmodule BEAMBetterHaveMyMoneyWeb.Types.TotalWorthChange do
  @moduledoc false
  use Absinthe.Schema.Notation
  @transaction_types BEAMBetterHaveMyMoney.Accounts.Wallet.transaction_types()

  @desc "The change in the total worth of a user after a given transaction in the transaction's currency"
  object :total_worth_change do
    field :user_id, non_null(:id)
    field :cent_amount, non_null(:integer)
    field :currency, non_null(:currency)
    field :transaction_type, non_null(:transaction_type)
  end

  @desc "The type of activity leading to a total worth change"
  enum :transaction_type, values: @transaction_types

end
