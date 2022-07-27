defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.TotalWorth do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.Wallet}

  @type resolution :: Absinthe.Resolution.t()
  @type currency :: Wallet.currency()
  @type total_worth :: %{user_id: non_neg_integer(), currency: currency(), cent_amount: integer()}
  @type params :: %{user_id: non_neg_integer(), currency: currency}

  @spec get_total_worth(params(), resolution()) ::
          {:ok, total_worth()} | {:error, ErrorMessage.t()}
  def get_total_worth(%{user_id: user_id, currency: target_currency}, _) do
    case Accounts.get_total_worth(%{user_id: user_id, currency: target_currency}) do
      {:ok, net_worth, _} ->
        {:ok, %{user_id: user_id, currency: target_currency, cent_amount: net_worth}}

      [] ->
        {:error,
         ErrorMessage.not_found("No wallets found for this User Id.", %{user_id: user_id})}

      error ->
        error
    end
  end
end
