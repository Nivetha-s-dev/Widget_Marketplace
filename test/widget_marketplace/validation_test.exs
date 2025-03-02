defmodule WidgetMarketplace.ValidationTest do
  use ExUnit.Case
  alias WidgetMarketplace.Validation
  alias WidgetMarketplace.Error

  describe "amount validation" do
    test "validates positive number" do
      assert {:ok, decimal} = Validation.validate_amount(100)
      assert Decimal.eq?(decimal, Decimal.new("100"))
    end

    test "rejects negative number" do
      assert {:error, %Error.InvalidAmount{}} = Validation.validate_amount(-100)
    end

    test "rejects zero" do
      assert {:error, %Error.InvalidAmount{}} = Validation.validate_amount(0)
    end

    test "rejects non-numeric values" do
      assert {:error, %Error.InvalidAmount{}} = Validation.validate_amount("invalid")
    end
  end

  describe "funds validation" do
    test "validates sufficient funds" do
      balance = Decimal.new("100")
      required = Decimal.new("50")
      assert :ok = Validation.validate_sufficient_funds(balance, required)
    end

    test "validates exact funds" do
      balance = Decimal.new("100")
      required = Decimal.new("100")
      assert :ok = Validation.validate_sufficient_funds(balance, required)
    end

    test "rejects insufficient funds" do
      balance = Decimal.new("50")
      required = Decimal.new("100")
      assert {:error, %Error.InsufficientFunds{}} =
               Validation.validate_sufficient_funds(balance, required)
    end
  end

  describe "widget availability validation" do
    test "validates available widget" do
      widget = %{status: "available"}
      assert :ok = Validation.validate_widget_availability(widget)
    end

    test "rejects sold widget" do
      widget = %{status: "sold"}
      assert {:error, %Error.WidgetNotAvailable{}} =
               Validation.validate_widget_availability(widget)
    end
  end
end