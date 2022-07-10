defmodule BEAMBetterHaveMyMoney.Accounts.Wallet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias BEAMBetterHaveMyMoney.Accounts.User

  @type t :: %__MODULE__{
    id: pos_integer | nil,
    cent_amount: integer | nil,
    currency: String.t() | nil,
    user_id: pos_integer | nil
  }


  schema "wallets" do
    field :cent_amount, :integer
    field :currency, :string
    belongs_to :user, User

    timestamps()
  end

  @required_params [:currency, :cent_amount]

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint([:currency, :user_id])

  end
end
