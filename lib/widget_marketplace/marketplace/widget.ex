defmodule WidgetMarketplace.Marketplace.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "widgets" do
    field :description, :string
    field :price, :decimal
    field :status, :string, default: "available"

    belongs_to :seller, WidgetMarketplace.Accounts.User

    timestamps()
  end

  def changeset(widget, attrs) do
    widget
    |> cast(attrs, [:description, :price, :seller_id, :status])
    |> validate_required([:description, :price, :seller_id])
    |> validate_number(:price, greater_than: 0)
  end
end