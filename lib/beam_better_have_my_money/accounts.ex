defmodule BEAMBetterHaveMyMoney.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BEAMBetterHaveMyMoney.{Accounts.User, Accounts.Wallet}
  alias EctoShorts.Actions

  @type error :: ErrorMessage.t()

  @spec all_users(map) :: [User.t()]
  def all_users(params \\ %{}) do
    Actions.all(User, params)
  end

  @spec find_user(map) :: {:ok, User.t()} | {:error, error}
  def find_user(params) do
    Actions.find(User, params)
  end

  @spec create_user(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    Actions.create(User, params)
  end

  @spec update_user(pos_integer, map) :: {:ok, User.t()} | {:error, error | Ecto.Changeset.t()}
  def update_user(id, params) do
    with {:ok, user} <- find_user(%{id: id}) do
      Actions.update(User, user, params)
    end
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%User{} = user) do
    Actions.delete(user)
  end

  @spec all_wallets(map) :: [Wallet.t()]
  def all_wallets(params \\ %{}) do
    Actions.all(Wallet, params)
  end

  @spec find_wallet(map) :: {:ok, Wallet.t()} | {:error, error()}
  def find_wallet(params) do
    Actions.find(Wallet, params)
  end

  @spec create_wallet(map) :: {:ok, Wallet.t()} | {:error, Ecto.Changeset.t()}
  def create_wallet(params) do
    Actions.create(Wallet, params)
  end

  @doc """
  Updates a wallet based on the user_id and currency
  """
  @spec update_wallet(Wallet.t(), map()) :: {:ok, Wallet.t()} | {:error, error()}
  def update_wallet(%Wallet{user_id: user_id, currency: currency}, params) do
    with {:ok, wallet} <- find_wallet(%{user_id: user_id, currency: currency}) do
      Actions.update(Wallet, wallet, params)
    end
  end

  @doc """
  Deletes a wallet based on user_id and currency
  """
  @spec delete_wallet(Wallet.t()) :: {:ok, Wallet.t()} | {:error, Ecto.Changeset.t()}
  def delete_wallet(%Wallet{user_id: user_id, currency: currency}) do
    with {:ok, wallet} <- find_wallet(%{user_id: user_id, currency: currency}) do
      Actions.delete(wallet)
    end
  end
end
