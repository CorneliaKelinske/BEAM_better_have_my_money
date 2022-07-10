defmodule BEAMBetterHaveMyMoney.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias BEAMBetterHaveMyMoney.Accounts.Wallet

  @type t :: %__MODULE__{
    id: pos_integer | nil,
    name: String.t() | nil,
    email: String.t() | nil
  }

  schema "users" do
    field :email, :string
    field :name, :string

    has_many :wallets, Wallet

    timestamps()
  end

  @required_params [:name, :email]

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email)
  end
end
