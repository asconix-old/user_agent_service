defmodule UserAgentService do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(UserAgentService.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: UserAgentService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
