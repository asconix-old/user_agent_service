defmodule UserAgentService.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  def conf(env), do: parse_url url(env)

  defp url(:dev),  do: "ecto://uagen@localhost/uagen_dev"
  defp url(:test), do: "ecto://uagen@localhost/uagen_test"
  defp url(:prod), do: "ecto://postgres:postgres@localhost/uagen"

  def priv do
    app_dir(:user_agent_service, "priv/repo")
  end
end