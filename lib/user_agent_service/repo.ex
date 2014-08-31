defmodule UserAgentService.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
  	"ecto://useragentservice:UserAgentService@localhost/user_agent_service"
  end

  def conf, do: parse_url url

  def priv do
    app_dir(:user_agent_service, "priv/repo")
  end
end