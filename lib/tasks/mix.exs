defmodule UserAgentService.Mixfile do
  use Mix.Project

  def project do
    [ app: :user_agent_service,
      version: "0.0.1",
      elixir: "~> 0.15.1",
      elixirc_paths: ["lib", "web"],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { UserAgentService, [] },
      applications: [
        :inets,
        :phoenix,
        :cowboy,
        :logger,
        :hackney,
        :httpoison
      ]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix"},
      {:cowboy, "~> 1.0.0"},
      {:postgrex, "~> 0.5.5"},
      {:ecto, "~> 0.2.3"},
      {:hackney, "~> 0.13.1"},
      {:httpoison, "~> 0.4.1"}      
    ]
  end
end
