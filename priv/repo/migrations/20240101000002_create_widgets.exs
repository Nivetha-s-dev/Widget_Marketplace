defmodule WidgetMarketplace.Repo.Migrations.CreateWidgets do
  use Ecto.Migration

  def change do
    create table(:widgets) do
      add :description, :string, null: false
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :status, :string, default: "available"
      add :seller_id, references(:users, on_delete: :restrict)

      timestamps()
    end

    create index(:widgets, [:seller_id])
  end
end