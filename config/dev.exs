use Mix.Config

config :phoenix, UserAgentService.Router,
  port: System.get_env("PORT") || 4000,
  ssl: false,
  host: "localhost",
  cookies: true,
  consider_all_requests_local: true,
  session_key: "_user_agent_service_key",
  session_secret: "%FW^OS#_DK4#7$5U)E6UOR4Z1%_YX74FGE4PW73M=NIJ1%W1874I(0=Y^53XC5)OLI2E"

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug


