defmodule WidgetMarketplace.Validation do
  alias WidgetMarketplace.Error

  def validate_amount(amount) do
    case WidgetMarketplace.Helpers.to_decimal(amount) do
      {:ok, decimal} -> {:ok, decimal}
      _ -> {:error, %Error.InvalidAmount{}}
    end
  end

  def validate_sufficient_funds(balance, required) do
    case Decimal.cmp(balance, required) do
      :lt -> {:error, %Error.InsufficientFunds{}}
      _ -> :ok
    end
  end

  def validate_widget_availability(widget) do
    if widget.status == "available" do
      :ok
    else
      {:error, %Error.WidgetNotAvailable{}}
    end
  end
end