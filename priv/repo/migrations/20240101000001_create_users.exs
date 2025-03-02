defmodule WidgetMarketplace.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :balance, :decimal, precision: 10, scale: 2, default: 0.00

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end