defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.User do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.User}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: BEAMBetterHaveMyMoney.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [User.t()]} | {:error, error}
  def all(params, _) do
    {:ok, Accounts.all_users(params)}
  end

  @spec find(map, resolution()) :: {:ok, User.t()} | {:error, error}
  def find(params, _) do
    Accounts.find_user(params)
  end
end
