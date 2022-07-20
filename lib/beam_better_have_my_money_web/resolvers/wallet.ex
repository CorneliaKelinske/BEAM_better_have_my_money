defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.Wallet do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.Wallet}

  @type resolution :: Absinthe.Resolution.t()

  @spec all(map, resolution()) :: {:ok, [Wallet.t()]} | {:error, ErrorMessage.t()}
  def all(params, _) do
    {:ok, Accounts.all_wallets(params)}
  end

  @spec find(map, resolution()) :: {:ok, Wallet.t()} | {:error, ErrorMessage.t()}
  def find(%{id: _id} = params, _) when map_size(params) === 1 do
    Accounts.find_wallet(params)
  end

  def find(%{user_id: _user_id, currency: _currency} = params, _) when map_size(params) === 2 do
    Accounts.find_wallet(params)
  end

  def find(params, _) do
    {:error,
     ErrorMessage.bad_request("Please search either by id or by user_id and currency", params)}
  end
end
