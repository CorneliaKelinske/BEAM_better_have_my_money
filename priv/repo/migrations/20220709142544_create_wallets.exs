defmodule BEAMBetterHaveMyMoney.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :currency, :text
      add :cent_amount, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:wallets, [:user_id])
    create unique_index(:wallets, [:currency, :user_id])
  end
end
