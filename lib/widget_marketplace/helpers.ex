defmodule WidgetMarketplace.Helpers do
  def to_decimal(amount) when is_binary(amount) do
    case Decimal.parse(amount) do
      {decimal, ""} -> {:ok, decimal}
      _ -> {:error, :invalid_amount}
    end
  end
  def to_decimal(amount) when is_number(amount) and amount > 0 do
    {:ok, Decimal.new(amount)}
  end
  def to_decimal(_), do: {:error, :invalid_amount}

  def calculate_marketplace_fee(amount) do
    fee_rate = Decimal.new("0.05")
    Decimal.mult(amount, fee_rate)
  end
end