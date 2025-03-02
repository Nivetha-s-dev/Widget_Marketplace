defmodule WidgetMarketplace.AccountsTest do
  use WidgetMarketplace.DataCase
  alias WidgetMarketplace.Accounts

  describe "users" do
    @valid_attrs %{
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com"
    }
    @invalid_attrs %{
      first_name: nil,
      last_name: nil,
      email: nil
    }

    test "create_user/1 with valid data creates a user" do
      assert {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "John"
      assert user.last_name == "Doe"
      assert user.email == "john@example.com"
      assert Decimal.eq?(user.balance, Decimal.new("0.00"))
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email format returns error" do
      attrs = %{@valid_attrs | email: "invalid_email"}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
    end

    test "create_user/1 enforces unique email" do
      assert {:ok, _user1} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end
  end

  describe "money operations" do
    setup do
      {:ok, user} = Accounts.create_user(%{
        first_name: "Test",
        last_name: "User",
        email: "test@example.com"
      })
      %{user: user}
    end

    test "deposit_money/2 adds money to user balance", %{user: user} do
      assert {:ok, updated_user} = Accounts.deposit_money(user.id, 100)
      assert Decimal.eq?(updated_user.balance, Decimal.new("100.00"))
    end

    test "deposit_money/2 with negative amount returns error", %{user: user} do
      assert {:error, :invalid_amount} = Accounts.deposit_money(user.id, -100)
    end

    test "deposit_money/2 with zero amount returns error", %{user: user} do
      assert {:error, :invalid_amount} = Accounts.deposit_money(user.id, 0)
    end

    test "deposit_money/2 with non-existent user returns error" do
      assert {:error, :user_not_found} = Accounts.deposit_money(0, 100)
    end
  end
end