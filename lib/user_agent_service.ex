defmodule UserAgentService do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(UserAgentService.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: UserAgentService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
