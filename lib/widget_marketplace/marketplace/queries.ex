defmodule WidgetMarketplace.Marketplace.Queries do
  import Ecto.Query
  alias WidgetMarketplace.Marketplace.{Widget, Transaction}

  def available_widgets_query do
    from w in Widget,
         where: w.status == "available",
         preload: [:seller]
  end

  def user_transactions_query(user_id) do
    from t in Transaction,
         where: t.buyer_id == ^user_id or t.seller_id == ^user_id,
         preload: [:widget, :buyer, :seller]
  end

  def user_widgets_query(user_id) do
    from w in Widget,
         where: w.seller_id == ^user_id,
         preload: [:seller]
  end
end