defmodule BEAMBetterHaveMyMoney.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BEAMBetterHaveMyMoney.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> BEAMBetterHaveMyMoney.Accounts.create_user()

    user
  end

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(attrs \\ %{}) do
    {:ok, wallet} =
      attrs
      |> Enum.into(%{
        cent_amount: 42,
        currency: "some currency"
      })
      |> BEAMBetterHaveMyMoney.Accounts.create_wallet()

    wallet
  end
end
