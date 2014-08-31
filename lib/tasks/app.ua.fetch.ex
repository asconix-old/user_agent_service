defmodule Mix.Tasks.App.Ua.Fetch do
	use Mix.Task

	@shortdoc "Fetch User-Agent strings (www.useragentstring.com)"

	@moduledoc '''
	Fetch HTTP User-Agent strings from www.useragentstring.com
	'''

	def run(_) do
		HTTPoison.start
		create_ua_dir
		iter(urls)
	end

	defp ua_dir do
		Path.dirname(__ENV__.file) <> "/../data/user_agents" |> Path.expand
	end

  defp create_ua_dir do
  	case File.rm_rf(ua_dir) do
  		{:ok, _} -> File.mkdir_p(ua_dir)
  		{:error, :enoent} ->
  			IO.puts "Something happened"
  	end 
	end

	defp request(url) do
		HTTPoison.get(url, []).body
	end

	defp parse(html) do
		doc = :mochiweb_html.parse(:erlang.bitstring_to_list(html))
		:mochiweb_xpath.execute('//div[@id="liste"]/ul/li/a/text()', doc)
	end

	defp write(user_agents, type) do
		File.write!(
			ua_dir <> "/" <> type <> ".txt",
			Enum.map(user_agents, fn(ua) -> "#{ua}\n" end)
		)
	end

  defp iter([]), do: IO.puts "All user agents have been fetched"

	defp iter([h|t]) do
		IO.puts "Fetching #{elem(h,1)}"
		elem(h,1) |> request |> parse |> write(to_string(elem(h,0)))
		iter t
	end

 	defp urls do
		[
			{:crawler, "http://www.useragentstring.com/pages/Crawlerlist/"},
			{:desktop_browser, "http://www.useragentstring.com/pages/Browserlist/"},
  		{:mobile_browser, "http://www.useragentstring.com/pages/Mobile%20Browserlist/"},
  		{:console, "http://www.useragentstring.com/pages/Consolelist/"},
  		{:offline_browser, "http://www.useragentstring.com/pages/Offline%20Browserlist/"},
  		{:email_client, "http://www.useragentstring.com/pages/E-mail%20Clientlist/"},
  		{:link_checker, "http://www.useragentstring.com/pages/Link%20Checkerlist/"},
  		{:email_collector, "http://www.useragentstring.com/pages/E-mail%20Collectorlist/"},
  		{:validator, "http://www.useragentstring.com/pages/Validatorlist/"},
  		{:feed_reader, "http://www.useragentstring.com/pages/Feed%20Readerlist/"},
  		{:library, "http://www.useragentstring.com/pages/Librarielist/"},
  		{:cloud_platform, "http://www.useragentstring.com/pages/Cloud%20Platformlist/"},
  		{:other, "http://www.useragentstring.com/pages/Otherlist/"}
  	]
	end
end