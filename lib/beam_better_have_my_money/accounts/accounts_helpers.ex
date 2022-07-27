defmodule BEAMBetterHaveMyMoney.Accounts.AccountsHelpers do
  @moduledoc """
  All the functions used in the Ecto.Multi in send_amount/1
  in the accounts context module.
  """
  alias BEAMBetterHaveMyMoney.{Accounts.Wallet, Config, ExchangeRateStorage}

  @type currency :: Wallet.currency()

  @spec find_and_lock_from_wallet(%{from_user_id: non_neg_integer(), from_currency: currency()}) ::
          Ecto.Query.t()
  def find_and_lock_from_wallet(%{from_user_id: from_user_id, from_currency: from_currency}) do
    Wallet
    |> Wallet.by_user_id_and_currency(from_user_id, from_currency)
    |> Wallet.lock_for_update()
  end

  @spec find_and_lock_to_wallet(%{to_user_id: non_neg_integer(), to_currency: currency()}) ::
          Ecto.Query.t()
  def find_and_lock_to_wallet(%{to_user_id: to_user_id, to_currency: to_currency}) do
    Wallet
    |> Wallet.by_user_id_and_currency(to_user_id, to_currency)
    |> Wallet.lock_for_update()
  end

  @spec check_wallets_found(any, %{find_from_wallet: Wallet.t(), find_to_wallet: Wallet.t()}) ::
          {:ok, true} | {:error, ErrorMessage.t()}
  def check_wallets_found(_, %{find_from_wallet: %Wallet{}, find_to_wallet: %Wallet{}}) do
    {:ok, true}
  end

  def check_wallets_found(_, _) do
    {:error, ErrorMessage.not_found("One of the wallets was not found")}
  end

  @spec exchange_rate(any, %{from_currency: currency(), to_currency: currency()}) ::
          {:ok, float()} | {:error, ErrorMessage.t()}
  def exchange_rate(_, %{from_currency: currency, to_currency: currency}) do
    {:ok, 1.0}
  end

  def exchange_rate(_, %{from_currency: from_currency, to_currency: to_currency}) do
    ExchangeRateStorage.get_exchange_rate(from_currency, to_currency)
  end

  @spec update_from_wallet(%{find_from_wallet: Wallet.t(), cent_amount: non_neg_integer()}) ::
          Ecto.Changeset.t()
  def update_from_wallet(%{
        find_from_wallet: %Wallet{cent_amount: from_wallet_cent_amount} = from_wallet,
        cent_amount: cent_amount
      }) do
    Ecto.Changeset.change(from_wallet, cent_amount: from_wallet_cent_amount - cent_amount)
  end

  @spec update_to_wallet(%{
          find_to_wallet: Wallet.t(),
          cent_amount: non_neg_integer(),
          exchange_rate: float()
        }) :: Ecto.Changeset.t()
  def update_to_wallet(%{
        find_to_wallet: %Wallet{cent_amount: to_wallet_cent_amount} = to_wallet,
        cent_amount: cent_amount,
        exchange_rate: exchange_rate
      }) do
    Ecto.Changeset.change(to_wallet,
      cent_amount: to_wallet_cent_amount + round(cent_amount * exchange_rate)
    )
  end


  @spec reduce_wallets(BEAMBetterHaveMyMoney.Accounts.Wallet.t(), {:ok, {:ok, integer(), currency()}, currency() }) ::
          {:cont, {:ok, integer(), currency()}} | {:halt, {:error, ErrorMessage.t()}}
  def reduce_wallets(%Wallet{currency: currency, cent_amount: cent_amount}, {:ok, acc, currency}) do
    {:cont, {:ok, acc + cent_amount, currency}}
  end

  def reduce_wallets(
         %Wallet{currency: currency, cent_amount: cent_amount},
         {:ok, acc, target_currency}
       ) do
    case ExchangeRateStorage.get_exchange_rate(currency, target_currency, cache_name()) do
      {:ok, exchange_rate} ->
        {:cont, {:ok, acc + round(cent_amount * exchange_rate), target_currency}}

      {:error, error} ->
        {:halt, {:error, error}}
    end
  end

  defp cache_name do
    case Config.env() do
      :test -> :test_cache
      _ -> :exchange_rate_cache
    end
  end
end
