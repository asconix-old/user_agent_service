defmodule UserAgentService.Router do
  import Plug.Conn
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :user_agent_service
#  plug PlugBasicAuth, username: "Wayne", password: "Knight"
#  plug :match
#  plug :dispatch

  get "/", UserAgentService.WelcomeController, :index, as: :root
  get "/user_agents", UserAgentService.UserAgentController, :index, as: :user_agents
  get "/user_agents/:user_agent", UserAgentService.UserAgentController, :show, as: :user_agent

end
