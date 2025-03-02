defmodule WidgetMarketplace.Marketplace do
  import Ecto.Query
  alias WidgetMarketplace.Repo
  alias WidgetMarketplace.Marketplace.{Widget, Transaction, Queries}
  alias WidgetMarketplace.Accounts.User
  alias WidgetMarketplace.Error
  alias Ecto.Multi

  @marketplace_fee_rate Decimal.new("0.05")

  def list_widgets(filters \\ %{}) do
    Widget
    |> apply_filters(filters)
    |> Repo.all()
    |> Repo.preload(:seller)
  end

  def get_user_transactions(user_id) do
    user_id
    |> Queries.user_transactions_query()
    |> Repo.all()
  end

  def get_user_widgets(user_id) do
    user_id
    |> Queries.user_widgets_query()
    |> Repo.all()
  end

  def purchase_widget(widget_id, buyer_id) do
    Repo.transaction(fn ->
      with {:ok, widget} <- fetch_widget(widget_id),
           {:ok, buyer} <- fetch_user(buyer_id),
           {:ok, seller} <- fetch_user(widget.seller_id),
           :ok <- validate_purchase(widget, buyer) do
        process_purchase(widget, buyer, seller)
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp apply_filters(query, filters) do
    Enum.reduce(filters, query, fn
      {:price_min, price}, query ->
        where(query, [w], w.price >= ^price)
      {:price_max, price}, query ->
        where(query, [w], w.price <= ^price)
      {:seller_id, seller_id}, query ->
        where(query, [w], w.seller_id == ^seller_id)
      _, query ->
        query
    end)
  end

  defp fetch_widget(id) do
    case Repo.get(Widget, id) do
      nil -> {:error, %Error.WidgetNotAvailable{}}
      widget -> {:ok, widget}
    end
  end

  defp fetch_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, %Error.UserNotFound{}}
      user -> {:ok, user}
    end
  end

  defp process_purchase(widget, buyer, seller) do
    fee = calculate_fee(widget.price)
    seller_amount = Decimal.sub(widget.price, fee)

    Multi.new()
    |> Multi.update(:widget,
         Widget.changeset(widget, %{status: "sold"}))
    |> Multi.update(:buyer,
         User.changeset(buyer, %{
           balance: Decimal.sub(buyer.balance, widget.price)
         }))
    |> Multi.update(:seller,
         User.changeset(seller, %{
           balance: Decimal.add(seller.balance, seller_amount)
         }))
    |> Multi.insert(:transaction,
         Transaction.changeset(%Transaction{}, %{
           seller_id: seller.id,
           buyer_id: buyer.id,
           widget_id: widget.id,
           amount: widget.price,
           marketplace_fee: fee
         }))
    |> Repo.transaction()
  end
end