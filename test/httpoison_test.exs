defmodule HTTPoisonTest do
  use ExUnit.Case
  
  test "parsing content of a page" do
 	response = HTTPoison.get("http://www.example.com", [])
 	assert Regex.match?(~r/illustrative examples/, response.body)
  end
end