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
      {:plug, github: "elixir-lang/plug", override: true},
      {:cowboy, "~> 1.0.0"},
      {:phoenix, github: "phoenixframework/phoenix"},
      {:postgrex, "~> 0.5.5"},
      {:ecto, "~> 0.2.3"},
      {:hackney, "~> 0.13.1"},
      {:httpoison, "~> 0.4.1"},
      {:mochiweb_xpath, github: "retnuh/mochiweb_xpath"},
      {:plug_basic_auth, github: "chrismccord/plug_basic_auth", branch: "cm/refactor-wrapper-into-call"}      
    ]
  end
end
