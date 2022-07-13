defmodule BEAMBetterHaveMyMoneyWeb.Types.Currency do
  @moduledoc false
  use Absinthe.Schema.Notation

  @currencies BEAMBetterHaveMyMoney.Config.currencies()

  @desc "A currency in which amounts can be stored in a wallet"
  enum :currency, values: @currencies
end
