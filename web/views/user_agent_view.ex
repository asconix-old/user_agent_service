defmodule UserAgentService.UserAgentView do
  use UserAgentService.Views
  alias Poison, as: JSON
 
  def render("show.json", %{user_agent: user_agent}) do
    user_agent
    |> to_map
    |> JSON.encode!
  end
 
  def render("index.json", %{user_agents: user_agents}) do
    user_agents
    |> Enum.map(&to_map(&1))
    |> JSON.encode!
  end
 
  defp to_map(user_agent = %UserAgentService.UserAgent{}) do
    %{
      type: user_agent.type,
      string: user_agent.string
    }
  end
end