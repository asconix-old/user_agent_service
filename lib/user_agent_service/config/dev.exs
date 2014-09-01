use Mix.Config

config :phoenix, UserAgentService.Router,
  port: System.get_env("PORT") || 4000,
  ssl: false,
  host: "localhost",
  cookies: true,
  session_key: "_your_app_key",
  session_secret: "$+X2PG$PX0^88^HXB)...",
  debug_errors: true

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug