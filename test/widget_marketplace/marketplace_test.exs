defmodule WidgetMarketplace.MarketplaceTest do
  use WidgetMarketplace.DataCase
  alias WidgetMarketplace.{Accounts, Marketplace}

  describe "marketplace operations" do
    setup do
      {:ok, seller} = Accounts.create_user(%{
        first_name: "John",
        last_name: "Doe",
        email: "seller@example.com"
      })

      {:ok, buyer} = Accounts.create_user(%{
        first_name: "Jane",
        last_name: "Smith",
        email: "buyer@example.com"
      })

      {:ok, %{buyer: buyer_with_balance}} = Accounts.deposit_money(buyer.id, 100)

      {:ok, widget} = Marketplace.create_widget(%{
        description: "Test Widget",
        price: "50.00",
        seller_id: seller.id
      })

      %{
        seller: seller,
        buyer: buyer_with_balance,
        widget: widget
      }
    end

    test "successful widget purchase", %{buyer: buyer, widget: widget} do
      {:ok, result} = Marketplace.purchase_widget(widget.id, buyer.id)

      assert result.transaction.amount == Decimal.new("50.00")
      assert result.transaction.marketplace_fee == Decimal.new("2.50")
      assert Decimal.eq?(result.buyer.balance, Decimal.new("50.00"))
      assert Decimal.eq?(result.seller.balance, Decimal.new("47.50"))
      assert result.widget.status == "sold"
    end

    test "prevents purchase with insufficient funds", %{widget: widget} do
      {:ok, poor_buyer} = Accounts.create_user(%{
        first_name: "Poor",
        last_name: "Buyer",
        email: "poor@example.com"
      })

      assert {:error, :insufficient_funds} =
               Marketplace.purchase_widget(widget.id, poor_buyer.id)
    end

    test "prevents purchase of already sold widget", %{buyer: buyer, widget: widget} do

      {:ok, _} = Marketplace.purchase_widget(widget.id, buyer.id)


      {:ok, another_buyer} = Accounts.create_user(%{
        first_name: "Another",
        last_name: "Buyer",
        email: "another@example.com"
      })
      {:ok, _} = Accounts.deposit_money(another_buyer.id, 100)

      assert {:error, :widget_not_available} =
               Marketplace.purchase_widget(widget.id, another_buyer.id)
    end
  end
end