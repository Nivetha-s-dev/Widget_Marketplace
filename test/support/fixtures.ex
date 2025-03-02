defmodule WidgetMarketplace.Fixtures do
  alias WidgetMarketplace.{Accounts, Marketplace}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "Test",
        last_name: "User",
        email: "test#{System.unique_integer()}@example.com"
      })
      |> Accounts.create_user()

    user
  end

  def widget_fixture(attrs \\ %{}) do
    seller = attrs[:seller] || user_fixture()

    {:ok, widget} =
      attrs
      |> Enum.into(%{
        description: "Test Widget",
        price: "50.00",
        seller_id: seller.id
      })
      |> Marketplace.create_widget()

    widget
  end
end