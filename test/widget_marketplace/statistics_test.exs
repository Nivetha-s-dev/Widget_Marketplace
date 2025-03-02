defmodule WidgetMarketplace.StatisticsTest do
  use WidgetMarketplace.DataCase
  alias WidgetMarketplace.{Accounts, Marketplace, Statistics}

  setup do
    {:ok, seller} = Accounts.create_user(%{
      first_name: "Seller",
      last_name: "Test",
      email: "seller@test.com"
    })

    {:ok, buyer} = Accounts.create_user(%{
      first_name: "Buyer",
      last_name: "Test",
      email: "buyer@test.com"
    })

    {:ok, %{buyer: buyer_with_money}} = Accounts.deposit_money(buyer.id, 1000)

    {:ok, widget} = Marketplace.create_widget(%{
      description: "Test Widget",
      price: "100.00",
      seller_id: seller.id
    })

    {:ok, %{transaction: transaction}} = Marketplace.purchase_widget(widget.id, buyer.id)

    %{
      seller: seller,
      buyer: buyer_with_money,
      widget: widget,
      transaction: transaction
    }
  end

  test "get_marketplace_statistics", %{transaction: transaction} do
    stats = Statistics.get_marketplace_statistics()

    assert stats.total_transactions == 1
    assert Decimal.eq?(stats.total_fees, transaction.marketplace_fee)
    assert Decimal.eq?(stats.total_volume, transaction.amount)
  end

  test "get_user_statistics", %{buyer: buyer, seller: seller, transaction: transaction} do
    buyer_stats = Statistics.get_user_statistics(buyer.id)
    seller_stats = Statistics.get_user_statistics(seller.id)

    assert Decimal.eq?(buyer_stats.purchases.total_spent, transaction.amount)
    assert buyer_stats.purchases.count == 1
    assert Decimal.eq?(seller_stats.sales.total_earned, transaction.amount)
    assert seller_stats.sales.count == 1
  end
end