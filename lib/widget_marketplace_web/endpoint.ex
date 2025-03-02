defmodule WidgetMarketplaceWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :widget_marketplace


  @session_options [
    store: :cookie,
    key: "_widget_marketplace_key",
    signing_salt: "hg/h4ZH/"
  ]

  socket "/socket", WidgetMarketplaceWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]


  plug Plug.Static,
    at: "/",
    from: :widget_marketplace,
    gzip: false,
    only: ~w(css fonts images js favicon.ico)


  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :widget_marketplace
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug WidgetMarketplaceWeb.Router
end
