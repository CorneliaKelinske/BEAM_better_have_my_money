defmodule BEAMBetterHaveMyMoney.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BEAMBetterHaveMyMoney.Accounts` context.
  """
  alias BEAMBetterHaveMyMoney.Accounts

  @user_params %{name: "Harry", email: "email@example.com"}
  @wallet_params %{currency: :CAD, cent_amount: 1_000}
  @wallet2_params %{currency: :USD, cent_amount: 1_000}

  def user(_context) do
    {:ok, user} = Accounts.create_user(@user_params)

    %{user: user}
  end

  def wallet(%{user: user}) do
    {:ok, wallet} =
      @wallet_params
      |> Map.merge(%{user_id: user.id})
      |> Accounts.create_wallet()

    %{wallet: wallet}
  end

  def wallet2(%{user: user}) do
    {:ok, wallet2} =
      @wallet2_params
      |> Map.merge(%{user_id: user.id})
      |> Accounts.create_wallet()

    %{wallet2: wallet2}
  end
end
