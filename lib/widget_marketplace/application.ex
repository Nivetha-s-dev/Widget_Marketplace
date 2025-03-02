defmodule WidgetMarketplace.Application do
  use Application

  def start(_type, _args) do
    children = [
      WidgetMarketplace.Repo,
      {Phoenix.PubSub, name: WidgetMarketplace.PubSub},
    ]

    opts = [strategy: :one_for_one, name: WidgetMarketplace.Supervisor]
    Supervisor.start_link(children, opts)
  end
end