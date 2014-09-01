use Mix.Config

config :phoenix, UserAgentService.Router,
  port: System.get_env("PORT"),
  ssl: false,
  cookies: true,
  session_key: "_your_app_key",
  session_secret: "super secret"

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  level: :error

import_config "#{Mix.env}.exs"