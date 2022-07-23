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

  @spec create_wallet(map, resolution()) :: {:ok, Wallet.t()} | {:error, Ecto.Changeset.t()}
  def create_wallet(params, _) do
    Accounts.create_wallet(params)
  end

  @spec deposit_amount(map, resolution()) :: {:ok, Wallet.t()} | {:error, ErrorMessage.t()}
  def deposit_amount(%{user_id: user_id, currency: currency, cent_amount: cent_amount}, _)
      when cent_amount > 0 do
    Accounts.update_balance(%{user_id: user_id, currency: currency}, %{cent_amount: cent_amount})
  end

  def deposit_amount(%{cent_amount: cent_amount}, _) do
    {:error,
     ErrorMessage.bad_request("Please enter a positive integer!", %{
       cent_amount: cent_amount
     })}
  end

  @spec withdraw_amount(map, resolution()) :: {:ok, Wallet.t()} | {:error, ErrorMessage.t()}
  def withdraw_amount(%{user_id: user_id, currency: currency, cent_amount: cent_amount}, _)
      when cent_amount > 0 do
    Accounts.update_balance(%{user_id: user_id, currency: currency}, %{cent_amount: -cent_amount})
  end

  def withdraw_amount(%{cent_amount: cent_amount}, _) do
    {:error,
     ErrorMessage.bad_request("Please enter a positive integer!", %{
       cent_amount: cent_amount
     })}
  end

  def send_amount(%{cent_amount: cent_amount} = params, _) when cent_amount > 0 do
    {:ok, Accounts.send_amount(params)}
  end

  def send_amount(%{cent_amount: cent_amount}, _) do
    {:error,
    ErrorMessage.bad_request("Please enter a positive integer!", %{
      cent_amount: cent_amount
    })}
  end
end
