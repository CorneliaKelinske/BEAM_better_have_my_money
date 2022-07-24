defmodule BEAMBetterHaveMyMoney.Accounts.Wallet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BEAMBetterHaveMyMoney.Accounts.{User, Wallet}
  alias BEAMBetterHaveMyMoney.Config

  @currencies Config.currencies()
  @required_params [:currency, :cent_amount, :user_id]

  @type currency :: atom
  @type t :: %__MODULE__{
          id: pos_integer | nil,
          cent_amount: integer | nil,
          currency: currency | nil,
          user_id: pos_integer | nil
        }

  schema "wallets" do
    field :cent_amount, :integer
    field :currency, Ecto.Enum, values: @currencies
    belongs_to :user, User

    timestamps()
  end

  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(params) do
    changeset(%Wallet{}, params)
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint([:currency, :user_id])
  end

  @spec by_user_id(non_neg_integer()) :: Ecto.Query.t()
  @spec by_user_id(Ecto.Queryable.t(), non_neg_integer()) :: Ecto.Query.t()
  def by_user_id(query \\ Wallet, user_id) do
    where(query, [w], w.user_id == ^user_id)
  end

  @spec by_currency(currency()) :: Ecto.Query.t()
  @spec by_currency(Ecto.Queryable.t(), currency()) :: Ecto.Query.t()
  def by_currency(query \\ Wallet, currency) do
    where(query, [w], w.currency == ^currency)
  end

  @spec by_user_id_and_currency(non_neg_integer(), currency()) :: Ecto.Query.t()
  @spec by_user_id_and_currency(Ecto.Query.t(), non_neg_integer(), currency()) :: Ecto.Query.t()
  def by_user_id_and_currency(query \\ Wallet, user_id, currency) do
    query
    |> by_user_id(user_id)
    |> by_currency(currency)
  end

  @spec lock_for_update :: Ecto.Query.t()
  @spec lock_for_update(Ecto.Query.t()) :: Ecto.Query.t()
  def lock_for_update(query \\ Wallet) do
    lock(query, "FOR UPDATE")
  end
end
