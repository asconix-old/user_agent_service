# This file is responsible for configuring your application
use Mix.Config

# Note this file is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project.

config :phoenix, UserAgentService.Router,
  port: System.get_env("PORT"),
  ssl: false,
  static_assets: true,
  cookies: true,
  session_key: "_user_agent_service_key",
  session_secret: "%FW^OS#_DK4#7$5U)E6UOR4Z1%_YX74FGE4PW73M=NIJ1%W1874I(0=Y^53XC5)OLI2E"

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  handle_sasl_reports: true,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id],
  level: :debug

# Import environment specific config. Note, this must remain at the bottom of
# this file to properly merge your previous config entries.
import_config "#{Mix.env}.exs"
