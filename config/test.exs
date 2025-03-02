use Mix.Config

config :widget_marketplace, WidgetMarketplace.Repo,
  username: "postgres",
  password: "postgres",
  database: "widget_marketplace_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :widget_marketplace, WidgetMarketplaceWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
