defmodule Mix.Tasks.Playground do
	use Mix.Task

	@shortdoc "Fetch remote URL"

	def run(_) do
		HTTPoison.start
		HTTPoison.get("http://www.example.com", [])
	end
end