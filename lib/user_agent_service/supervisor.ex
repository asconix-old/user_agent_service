defmodule UserAgentService.Supervisor do
  use Supervisor
  # import Supervisor.Spec, warn: false

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(UserAgentService.Repo, []),
      worker(UserAgentService.Router, [], function: :start)
    ]
    opts = [strategy: :one_for_one, name: UserAgentService.Supervisor]

    supervise(children, opts)
  end
end
