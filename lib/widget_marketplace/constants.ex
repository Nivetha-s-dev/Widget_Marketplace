defmodule WidgetMarketplace.Constants do
  def marketplace_fee_rate, do: Decimal.new("0.05")

  def widget_statuses do
    %{
      available: "available",
      sold: "sold"
    }
  end
end