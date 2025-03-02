defmodule WidgetMarketplaceWeb.UserSocket do
  use Phoenix.Socket

  @impl Phoenix.Socket
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl Phoenix.Socket
  def id(_socket), do: nil
end
