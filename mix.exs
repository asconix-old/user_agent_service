defmodule UserAgentService.Mixfile do
  use Mix.Project

  def project do
    [ app: :user_agent_service,
      version: "0.0.1",
      elixir: "~> 1.0.0-rc1",
      elixirc_paths: ["lib", "web"],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { UserAgentService, [] },
      applications: [
        :inets,
        :plug,
        :plug_basic_auth,
        :cowboy,
        :phoenix,
        :logger,
        :hackney,
        :httpoison,
        :xmerl
      ]
    ]
  end

  defp deps do
    [
      {:plug, "~> 0.7.0"},
      {:cowboy, "~> 1.0.0"},
      {:phoenix, "~> 0.4.0"},
      {:postgrex, "~> 0.5.5"},
      {:ecto, "~> 0.2.3"},
      {:hackney, "~> 0.13.1"},
      {:httpoison, github: "edgurgel/httpoison"},
      {:mochiweb_xpath, github: "retnuh/mochiweb_xpath"},
      {:plug_basic_auth, "~> 0.2.0"}      
    ]
  end
end
