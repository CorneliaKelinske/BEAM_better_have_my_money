defmodule BEAMBetterHaveMyMoney.Accounts.AmountTransfer do
  alias BEAMBetterHaveMyMoney.{Accounts.Wallet, ExchangeRateStorage}

  def find_and_lock_from_wallet(%{from_user_id: from_user_id, from_currency: from_currency}) do
    Wallet
    |> Wallet.by_user_id_and_currency(from_user_id, from_currency)
    |> Wallet.lock_for_update()
  end

  def find_and_lock_to_wallet(%{to_user_id: to_user_id, to_currency: to_currency}) do
    Wallet
    |> Wallet.by_user_id_and_currency(to_user_id, to_currency)
    |> Wallet.lock_for_update()
  end

  def check_wallets_found(_, %{find_from_wallet: %Wallet{}, find_to_wallet: %Wallet{}}) do
    {:ok, true}
  end

  def check_wallets_found(_, _) do
    {:error, ErrorMessage.not_found("One of the wallets was not found")}
  end

  def exchange_rate(_, %{from_currency: currency, to_currency: currency}) do
    {:ok, 1}
  end

  def exchange_rate(_, %{from_currency: from_currency, to_currency: to_currency}) do
    ExchangeRateStorage.get_exchange_rate(from_currency, to_currency)
  end

  def update_from_wallet(%{find_from_wallet: from_wallet, cent_amount: cent_amount}) do
    Ecto.Changeset.change(from_wallet, cent_amount: from_wallet.cent_amount - cent_amount)
  end

  def update_to_wallet(%{
        find_to_wallet: to_wallet,
        cent_amount: cent_amount,
        exchange_rate: exchange_rate
      }) do
    Ecto.Changeset.change(to_wallet,
      cent_amount: to_wallet.cent_amount + cent_amount * exchange_rate
    )
  end
end
