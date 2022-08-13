defmodule BEAMBetterHaveMyMoneyWeb.Resolvers.User do
  @moduledoc false
  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.User}

  @type resolution :: Absinthe.Resolution.t()

  @spec all(map, resolution()) :: {:ok, [User.t()]} | {:error, ErrorMessage.t()}
  def all(params, _) do
    {:ok, Accounts.all_users(params)}
  end

  @spec find(map, resolution()) :: {:ok, User.t()} | {:error, ErrorMessage.t()}
  def find(params, _) do
    Accounts.find_user(params)
  end

  @spec create_user(map, resolution()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params, _) do
    Accounts.create_user(params)
  end

  @spec update_user(%{id: String.t()}, resolution()) ::
          {:ok, User.t()} | {:error, ErrorMessage.t() | Ecto.Changeset.t()}
  def update_user(%{id: id} = params, _) do
    id
    |> String.to_integer()
    |> Accounts.update_user(Map.delete(params, :id))
  end
end
