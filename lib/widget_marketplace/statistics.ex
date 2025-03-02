defmodule WidgetMarketplace.Statistics do
  import Ecto.Query
  alias WidgetMarketplace.Repo
  alias WidgetMarketplace.Marketplace.Transaction

  def get_marketplace_statistics do
    total_transactions = Repo.aggregate(Transaction, :count)
    total_fees = Repo.aggregate(Transaction, :sum, :marketplace_fee)
    total_volume = Repo.aggregate(Transaction, :sum, :amount)

    %{
      total_transactions: total_transactions,
      total_fees: total_fees,
      total_volume: total_volume
    }
  end

  def get_user_statistics(user_id) do
    purchases_query = from t in Transaction,
                           where: t.buyer_id == ^user_id,
                           select: %{
                             total_spent: sum(t.amount),
                             count: count()
                           }

    sales_query = from t in Transaction,
                       where: t.seller_id == ^user_id,
                       select: %{
                         total_earned: sum(t.amount),
                         count: count()
                       }

    %{
      purchases: Repo.one(purchases_query),
      sales: Repo.one(sales_query)
    }
  end
end