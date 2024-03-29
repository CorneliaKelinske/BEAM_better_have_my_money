defmodule BEAMBetterHaveMyMoney.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias BEAMBetterHaveMyMoney.Accounts.{User, Wallet}

  @required_params [:name, :email]

  @type t :: %__MODULE__{
          id: pos_integer | nil,
          name: String.t() | nil,
          email: String.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "users" do
    field :email, :string
    field :name, :string

    has_many :wallets, Wallet

    timestamps()
  end

  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(params) do
    changeset(%User{}, params)
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email)
  end
end
