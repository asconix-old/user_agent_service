require Record

defmodule HTMLParsingTest do
	Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
	Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
	use ExUnit.Case

	# Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
	# Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

	def sample_html do
		"""
		<html>
			<head>
			  <title>HTML parsing test</title>
			</head>
			<body>
			  <p>Lorem ipsum:</p>
			  <ul>
			    <li>First item</li>
			    <li>Second item</li>
			    <li>Third item</li>
			  </ul>
			</body>
		</html>
		"""
	end

	test "should parse the title" do
		doc = :mochiweb_html.parse(:erlang.bitstring_to_list(sample_html))
		[ title ] = :mochiweb_xpath.execute('/html/head/title/text()', doc)

		assert title == "HTML parsing test"
	end
end