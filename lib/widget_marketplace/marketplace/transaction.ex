defmodule WidgetMarketplace.Marketplace.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    belongs_to :seller, WidgetMarketplace.Accounts.User
    belongs_to :buyer, WidgetMarketplace.Accounts.User
    belongs_to :widget, WidgetMarketplace.Marketplace.Widget

    field :amount, :decimal
    field :marketplace_fee, :decimal

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:seller_id, :buyer_id, :widget_id, :amount, :marketplace_fee])
    |> validate_required([:seller_id, :buyer_id, :widget_id, :amount, :marketplace_fee])
  end
end