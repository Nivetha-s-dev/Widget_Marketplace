import Config

config :widget_marketplace,
       ecto_repos: [WidgetMarketplace.Repo]

config :widget_marketplace, WidgetMarketplace.Repo,
       database: "widget_marketplace_#{config_env()}",
       username: "postgres",
       password: "postgres",
       hostname: "localhost"

import_config "#{config_env()}.exs"