defmodule BEAMBetterHaveMyMoney.Accounts.Wallet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
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
end
