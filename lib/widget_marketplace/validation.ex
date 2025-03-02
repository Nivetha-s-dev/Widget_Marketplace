defmodule WidgetMarketplace.Validation do
  alias WidgetMarketplace.Error

  def validate_amount(amount) when is_number(amount) and amount > 0 do
    {:ok, Decimal.new(amount)}
  end
  def validate_amount(_), do: {:error, %Error.InvalidAmount{}}

  def validate_sufficient_funds(balance, required_amount) do
    case Decimal.cmp(balance, required_amount) do
      :lt -> {:error, %Error.InsufficientFunds{}}
      _ -> :ok
    end
  end

  def validate_widget_availability(widget) do
    case widget.status do
      "available" -> :ok
      _ -> {:error, %Error.WidgetNotAvailable{}}
    end
  end
end

