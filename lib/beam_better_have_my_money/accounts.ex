defmodule BEAMBetterHaveMyMoney.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BEAMBetterHaveMyMoney.{Accounts.User, Accounts.Wallet, ExchangeRateStorage, Repo}
  alias EctoShorts.Actions

  @type error :: ErrorMessage.t()
  @type currency :: Wallet.currency()

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

  @spec update_balance(%{user_id: non_neg_integer(), currency: currency()}, %{
          cent_amount: integer()
        }) :: {:ok, Wallet.t()} | {:error, error()}
  def update_balance(%{user_id: user_id, currency: currency}, %{cent_amount: cent_amount}) do
    with {:ok, wallet} <- find_wallet(%{user_id: user_id, currency: currency}) do
      Actions.update(Wallet, wallet, %{cent_amount: wallet.cent_amount + cent_amount})
    end
  end

  def send_amount(%{
        from_user_id: from_user_id,
        from_currency: from_currency,
        cent_amount: cent_amount,
        to_user_id: to_user_id,
        to_currency: to_currency
      }) do
    Ecto.Multi.new()
    |> Ecto.Multi.put(:from_user_id, from_user_id)
    |> Ecto.Multi.put(:from_currency, from_currency)
    |> Ecto.Multi.put(:to_user_id, to_user_id)
    |> Ecto.Multi.put(:to_currency, to_currency)
    |> Ecto.Multi.put(:cent_amount, cent_amount)
    |> Ecto.Multi.one(:find_from_wallet, &find_from_wallet/1)
    |> Ecto.Multi.one(:find_to_wallet, &find_to_wallet/1)
    |> Ecto.Multi.run(:exchange_rate, fn _, _ ->
      maybe_get_exchange_rate(from_currency, to_currency)
    end)
    |> Ecto.Multi.update(:update_from_wallet, &update_from_wallet/1)
    |> Ecto.Multi.update(:update_to_wallet, &update_to_wallet/1)
    |> Repo.transaction()
  end

  defp find_from_wallet(%{from_user_id: from_user_id, from_currency: from_currency}) do
    from(w in Wallet, where: w.user_id == ^from_user_id and w.currency == ^from_currency)
  end

  defp find_to_wallet(%{to_user_id: to_user_id, to_currency: to_currency}) do
    from(w in Wallet, where: w.user_id == ^to_user_id and w.currency == ^to_currency)
  end

  defp update_from_wallet(%{find_from_wallet: from_wallet, cent_amount: cent_amount}) do
    Ecto.Changeset.change(from_wallet, cent_amount: from_wallet.cent_amount - cent_amount)
  end

  defp update_to_wallet(%{
         find_to_wallet: to_wallet,
         cent_amount: cent_amount,
         exchange_rate: exchange_rate
       }) do
    Ecto.Changeset.change(to_wallet,
      cent_amount: to_wallet.cent_amount + cent_amount * exchange_rate
    )
  end

  defp maybe_get_exchange_rate(from_currency, from_currency) do
    {:ok, 1}
  end

  defp maybe_get_exchange_rate(from_currency, to_currency) do
    ExchangeRateStorage.get_exchange_rate(from_currency, to_currency)
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
