defmodule UserAgentService do
  use Application

  def start(_type, _args) do
    {:ok, pid} = UserAgentService.Supervisor.start_link
  end
end
