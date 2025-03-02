defmodule WidgetMarketplace.Error do
  defmodule InvalidAmount do
    defexception message: "Invalid amount provided"
  end

  defmodule InsufficientFunds do
    defexception message: "Insufficient funds for transaction"
  end

  defmodule WidgetNotAvailable do
    defexception message: "Widget is not available for purchase"
  end

  defmodule UserNotFound do
    defexception message: "User not found"
  end
end