defmodule BEAMBetterHaveMyMoney.Accounts.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :cent_amount, :integer
    field :currency, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:currency, :cent_amount])
    |> validate_required([:currency, :cent_amount])
  end
end
