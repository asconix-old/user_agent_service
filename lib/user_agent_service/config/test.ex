defmodule UserAgentService.Config.Test do
  use UserAgentService.Config

  config :router, port: 4001,
                  ssl: false
  config :plugs, code_reload: true
  config :logger, level: :debug
end
