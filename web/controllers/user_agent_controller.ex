# defmodule UserAgentService.UserAgentController do
#   use Phoenix.Controller

#   def show(conn, %{"id" => id}) do
#     text conn, JSON.encode!(UserAgentService.Repo.get(UserAgentService.UserAgent, id))
#   end

#   def index(conn, _params) do
#     json conn, JSON.encode!(UserAgentService.Repo.all(UserAgentService.UserAgent))
#   end
# end

defmodule UserAgentService.UserAgentController do
  use Phoenix.Controller
  import Ecto.Query, only: [from: 2]

  plug :put_resp_content_type, "application/json"
 
 	# Show
  def show(conn, %{"id" => id}) do
    render conn, "show", user_agent: UserAgentService.Repo.get!(UserAgentService.UserAgent, id)
  end
 
 	# Index
	def index(conn, %{"type" => type, "limit" => limit}) do
  	{limit_int, _limit_rem} = Integer.parse(limit)
  	query = from ua in UserAgentService.UserAgent,
  			where: ua.type == ^type,
  			order_by: random(),
  			limit: limit_int,
  			select: ua
    render conn, "index", user_agents: UserAgentService.Repo.all(query)
  end

  def index(conn, %{"type" => type}) do
  	query = from ua in UserAgentService.UserAgent,
  			where: ua.type == ^type,
  			order_by: random(),
  			limit: 1,
  			select: ua
    render conn, "index", user_agents: UserAgentService.Repo.all(query)
  end

  def index(conn, %{"limit" => limit}) do
  	{limit_int, _limit_rem} = Integer.parse(limit)
  	query = from ua in UserAgentService.UserAgent,
  			# where: ua.type == "desktop_browser",
  			order_by: random(),
  			limit: limit_int,
  			select: ua
    render conn, "index", user_agents: UserAgentService.Repo.all(query)
  end

  def index(conn, _) do
  	query = from ua in UserAgentService.UserAgent,
  	    # where: ua.type == "desktop_browser",
  	    order_by: random(),
  	    limit: 1,
  	    select: ua
  	render conn, "index", user_agents: UserAgentService.Repo.all(query)
  end
 
  # def index(conn, params) do
  	# index conn, Dict.merge(params, %{"type" => "desktop_browser", "limit" => "50"})
	# end
end