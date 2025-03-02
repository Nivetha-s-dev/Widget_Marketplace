defmodule WidgetMarketplace.Accounts do
  alias WidgetMarketplace.Repo
  alias WidgetMarketplace.Accounts.User

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id), do: Repo.get(User, id)

  def deposit_money(user_id, amount) when is_number(amount) and amount > 0 do
    Repo.transaction(fn ->
      user = get_user(user_id)

      if user do
        new_balance = Decimal.add(user.balance, Decimal.new(amount))

        user
        |> User.changeset(%{balance: new_balance})
        |> Repo.update()
      else
        {:error, :user_not_found}
      end
    end)
  end
end