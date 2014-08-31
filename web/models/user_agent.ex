defmodule UserAgentService.UserAgent do
	use Ecto.Model

	schema "user_agents" do
    field :type
    field :string
  end

end