defmodule WidgetMarketplaceWeb do
  @moduledoc
  def controller do
    quote do
      use Phoenix.Controller, namespace: WidgetMarketplaceWeb

      import Plug.Conn
      import WidgetMarketplaceWeb.Gettext
      alias WidgetMarketplaceWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/widget_marketplace_web/templates",
        namespace: WidgetMarketplaceWeb

      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import WidgetMarketplaceWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.View

      import WidgetMarketplaceWeb.ErrorHelpers
      import WidgetMarketplaceWeb.Gettext

      alias WidgetMarketplaceWeb.Router.Helpers, as: Routes
    end
  end

  @doc
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
