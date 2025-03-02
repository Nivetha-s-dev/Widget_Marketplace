defmodule WidgetMarketplace.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :balance, :decimal, default: Decimal.new("0.00")

    has_many :widgets, WidgetMarketplace.Marketplace.Widget, foreign_key: :seller_id
    has_many :sales, WidgetMarketplace.Marketplace.Transaction, foreign_key: :seller_id
    has_many :purchases, WidgetMarketplace.Marketplace.Transaction, foreign_key: :buyer_id

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :balance])
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end