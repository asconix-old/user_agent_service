defmodule UserAgentService.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  def conf(:dev),
    do: parse_url "ecto://uagen@localhost/uagen_dev"
  
  def conf(:test),
    do: parse_url "ecto://uagen@localhost/uagen_test?size=1&max_overflow=0"
  
  def conf(:prod),
    do: parse_url(System.get_env("DATABASE_URL")) ++ [lazy: false]

  def priv do
    app_dir(:user_agent_service, "priv/repo")
  end
end
