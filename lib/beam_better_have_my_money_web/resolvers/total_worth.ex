defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.TotalWorth do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.Wallet, Config, ExchangeRateStorage}

  @type resolution :: Absinthe.Resolution.t()
  @type currency :: Wallet.currency()
  @type total_worth :: %{user_id: non_neg_integer(), currency: currency(), cent_amount: integer()}

  @env Config.env()

  def get_total_worth(%{user_id: user_id, currency: target_currency}, _) do
    acc = {:ok, 0, target_currency}

    with [_ | _] = wallets <- Accounts.all_wallets(%{user_id: user_id}),
         {:ok, net_worth, _} <- Enum.reduce_while(wallets, acc, &reduce_wallets/2) do
      {:ok, %{user_id: user_id, currency: target_currency, cent_amount: net_worth}}
    else
      [] ->
        {:error,
         ErrorMessage.not_found("No wallets found for this User Id.", %{
           user_id: user_id
         })}

      error ->
        error
    end
  end

  defp reduce_wallets(%Wallet{currency: currency, cent_amount: cent_amount}, {:ok, acc, currency}) do
    {:cont, {:ok, acc + cent_amount, currency}}
  end

  defp reduce_wallets(
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
    case @env do
      :test -> :test_cache
      _ -> :exchange_rate_cache
    end
  end
end
