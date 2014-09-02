defmodule Mix.Tasks.App.Ua.Import do
	use Mix.Task

	@shortdoc "Import User-Agent strings into local database"

	@moduledoc '''
	Import HTTP User-Agent strings into database
	'''

	def run(_) do
		Mix.Task.run "app.start", []
		iter
	end

	defp ua_dir do
        "#{:code.priv_dir(:user_agent_service)}/data/user_agents"
	end

  defp insert_to_db("", _string), do: {:error, "User-Agent type missing"}

  defp insert_to_db(_type, ""), do: {:error, "User-Agent string missing"}

	defp insert_to_db(type, string) do
		user_agent = %UserAgentService.UserAgent{type: type, string: string}
  	UserAgentService.Repo.insert user_agent
	end

  defp read(file) do
  	{:ok, user_agents} = File.read(file)
  	Enum.map(String.split(user_agents, "\n"), fn(ua) ->
  		insert_to_db(Path.basename(file, '.txt'), ua)
  	end)
  end

	defp get_listing do
		File.ls!(ua_dir)
        |> Enum.map(fn filename -> Path.join(ua_dir, filename) end)
        |> Enum.map&(String.to_char_list(&1))
	end

	defp iter do
		get_listing
		|> Enum.map(fn(file) -> read(file) end)
	end
end
