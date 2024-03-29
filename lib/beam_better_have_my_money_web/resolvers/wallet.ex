defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.Wallet do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.Wallet}

  @transaction_types Wallet.transaction_types()

  @type currency :: Wallet.currency()
  @type resolution :: Absinthe.Resolution.t()
  @type transaction :: %{
          from_wallet: Wallet.t(),
          cent_amount: non_neg_integer(),
          from_currency: currency(),
          to_currency: currency,
          to_wallet: Wallet.t()
        }

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
    with {:ok, %Wallet{} = wallet} <-
           Accounts.update_balance(%{user_id: user_id, currency: currency}, %{
             cent_amount: cent_amount
           }) do
      publish_total_worth_change(user_id, cent_amount, currency, :deposit)

      {:ok, wallet}
    end
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
    with {:ok, %Wallet{} = wallet} <-
           Accounts.update_balance(%{user_id: user_id, currency: currency}, %{
             cent_amount: -cent_amount
           }) do
      publish_total_worth_change(user_id, cent_amount, currency, :withdrawal)

      {:ok, wallet}
    end
  end

  def withdraw_amount(%{cent_amount: cent_amount}, _) do
    {:error,
     ErrorMessage.bad_request("Please enter a positive integer!", %{
       cent_amount: cent_amount
     })}
  end

  @spec send_amount(map, resolution()) :: {:ok, transaction()} | {:error, ErrorMessage.t()}
  def send_amount(%{cent_amount: cent_amount} = params, _)
      when cent_amount > 0 do
    case Accounts.send_amount(params) do
      {:ok,
       %{
         exchange_rate: exchange_rate,
         update_from_wallet:
           %Wallet{user_id: from_user_id, currency: from_currency} = from_wallet,
         update_to_wallet: %Wallet{user_id: to_user_id, currency: to_currency} = to_wallet
       }} ->
        publish_total_worth_change(from_user_id, cent_amount, from_currency, :withdrawal)

        publish_total_worth_change(
          to_user_id,
          round(cent_amount * exchange_rate),
          to_currency,
          :deposit
        )

        {:ok,
         %{
           from_wallet: from_wallet,
           cent_amount: cent_amount,
           from_currency: from_currency,
           to_currency: to_currency,
           exchange_rate: exchange_rate,
           to_wallet: to_wallet
         }}

      {:error, name, %ErrorMessage{details: details} = error_message, _} ->
        details = Map.put(details || %{}, :operation, name)
        {:error, %ErrorMessage{error_message | details: details}}
    end
  end

  def send_amount(%{cent_amount: cent_amount}, _) do
    {:error,
     ErrorMessage.bad_request("Please enter a positive integer!", %{
       cent_amount: cent_amount
     })}
  end

  defp publish_total_worth_change(user_id, cent_amount, currency, transaction_type)
       when transaction_type in @transaction_types do
    Absinthe.Subscription.publish(
      BEAMBetterHaveMyMoneyWeb.Endpoint,
      %{
        user_id: user_id,
        cent_amount: cent_amount,
        currency: currency,
        transaction_type: transaction_type
      },
      total_worth_changed: "user_total_worth_change:#{user_id}"
    )
  end
end
