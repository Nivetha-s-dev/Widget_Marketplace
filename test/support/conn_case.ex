defmodule WidgetMarketplaceWeb.ConnCase do
  @moduledoc

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL

  using do
    quote do

      import Plug.Conn
      import Phoenix.ConnTest
      import WidgetMarketplaceWeb.ConnCase

      alias WidgetMarketplaceWeb.Router.Helpers, as: Routes

      @endpoint WidgetMarketplaceWeb.Endpoint
    end
  end

  setup tags do
    :ok = SQL.Sandbox.checkout(WidgetMarketplace.Repo)

    unless tags[:async] do
      SQL.Sandbox.mode(WidgetMarketplace.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
