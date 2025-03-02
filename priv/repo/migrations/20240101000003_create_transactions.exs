defmodule WidgetMarketplace.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :seller_id, references(:users, on_delete: :restrict)
      add :buyer_id, references(:users, on_delete: :restrict)
      add :widget_id, references(:widgets, on_delete: :restrict)
      add :amount, :decimal, precision: 10, scale: 2, null: false
      add :marketplace_fee, :decimal, precision: 10, scale: 2, null: false

      timestamps()
    end

    create index(:transactions, [:seller_id])
    create index(:transactions, [:buyer_id])
    create index(:transactions, [:widget_id])
  end
end