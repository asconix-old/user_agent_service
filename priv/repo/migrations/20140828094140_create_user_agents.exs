defmodule UserAgentService.Repo.Migrations.CreateUserAgents do
  use Ecto.Migration

  def up do
    "CREATE TABLE user_agents (id serial primary key, string text UNIQUE, type text);"
  end

  def down do
    "DROP TABLE user_agents"
  end
end
