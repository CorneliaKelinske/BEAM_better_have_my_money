defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.Wallet do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.Wallet}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: BEAMBetterHaveMyMoney.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [Wallet.t()]} | {:error, error}
  def all(params, _) do
    {:ok, Accounts.all_wallets(params)}
  end

  @spec find(map, resolution()) :: {:ok, Wallet.t()} | {:error, error}
  def find(params, _) do
    Accounts.find_wallet(params)
  end
end
