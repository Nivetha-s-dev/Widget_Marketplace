use Mix.Config

config :widget_marketplace, WidgetMarketplace.Repo,
  username: "postgres",
  password: "postgres",
  database: "widget_marketplace_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :widget_marketplace, WidgetMarketplaceWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :widget_marketplace, WidgetMarketplaceWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/widget_marketplace_web/(live|views)/.*(ex)$",
      ~r"lib/widget_marketplace_web/templates/.*(eex)$"
    ]
  ]


config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
