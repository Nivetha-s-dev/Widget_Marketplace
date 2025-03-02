defmodule WidgetMarketplaceWeb.ChannelCase do
  @moduledoc

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL

  using do
    quote do

      import Phoenix.ChannelTest
      import WidgetMarketplaceWeb.ChannelCase
      @endpoint WidgetMarketplaceWeb.Endpoint
    end
  end

  setup tags do
    :ok = SQL.Sandbox.checkout(WidgetMarketplace.Repo)

    unless tags[:async] do
      SQL.Sandbox.mode(WidgetMarketplace.Repo, {:shared, self()})
    end

    :ok
  end
end
