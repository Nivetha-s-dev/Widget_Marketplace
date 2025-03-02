defmodule WidgetMarketplace do
  @moduledoc
  import Ecto.Query, only: [from: 2, where: 3]

  alias WidgetMarketplace.Repo
  alias WidgetMarketplace.Repo.Transaction
  alias WidgetMarketplace.Repo.User

  @doc
  def get(schema, id), do: Repo.get(schema, id)

  @doc
  def all(schema), do: Repo.all(schema)

  def all(schema, preloads) do
    schema
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  @doc
  def create(schema, attrs) do
    schema.__struct__
    |> schema.changeset(attrs)
    |> Repo.insert()
  end

  @doc
  def get_user_balance(%User{id: user_id}) do
    Transaction
    |> where([t], t.seller_id == ^user_id or t.buyer_id == ^user_id)
    |> Repo.all()
    |> Enum.reduce(0, fn %{seller_id: seller_id, buyer_id: buyer_id, amount: amount}, total ->
      cond do
        buyer_id == nil -> total + amount
        seller_id == user_id -> total + amount * 0.95
        true -> total - amount
      end
    end)
  end

  def get_user_balance(_), do: 0

  @doc
  def purchase_widget(%User{} = buyer, seller_id, widget_id, amount) do
    case WidgetMarketplace.get_user_balance(buyer) do
      balance when balance < amount ->
        {:error, :insufficient_funds}

      _ ->
        WidgetMarketplace.create(Transaction, %{
          seller_id: seller_id,
          buyer_id: buyer.id,
          widget_id: widget_id,
          amount: amount
        })
    end
  end

  @doc
  def authenticate(email, plaintext_password) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(plaintext_password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
