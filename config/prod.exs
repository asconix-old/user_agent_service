use Mix.Config

# NOTE: To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on disk
# for the key and cert

config :phoenix, UserAgentService.Router,
  port: System.get_env("PORT"),
  ssl: false,
  host: "example.com",
  cookies: true,
  session_key: "_user_agent_service_key",
  session_secret: "%FW^OS#_DK4#7$5U)E6UOR4Z1%_YX74FGE4PW73M=NIJ1%W1874I(0=Y^53XC5)OLI2E"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id],
  level: :info
