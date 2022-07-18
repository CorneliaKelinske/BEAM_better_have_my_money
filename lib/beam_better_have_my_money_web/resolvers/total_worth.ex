defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.TotalWorth do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, ExchangeRateStorage}

  def get_total_worth(%{user_id: user_id, currency: target_currency}, _) do
    wallets = Accounts.all_wallets(%{user_id: user_id})

    {:ok,
     %{
       cent_amount:
         Enum.reduce(wallets, 0, fn x, acc ->
           acc + convert_amount(x.cent_amount, x.currency, target_currency)
         end)
     }}
  end

  defp convert_amount(cent_amount, currency, target_currency) when currency === target_currency do
    cent_amount
  end

  defp convert_amount(cent_amount, currency, target_currency) do
    exchange_rate = ExchangeRateStorage.get_exchange_rate(currency, target_currency)
    cent_amount * exchange_rate
  end
end
