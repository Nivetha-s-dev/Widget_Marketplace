defmodule WidgetMarketplace.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias WidgetMarketplace.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import WidgetMarketplace.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(WidgetMarketplace.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(WidgetMarketplace.Repo, {:shared, self()})
    end

    :ok
  end
end