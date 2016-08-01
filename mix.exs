defmodule Pokerap.Mixfile do
  use Mix.Project

  @description """
  Wrapper library for the Pokeapi (http://pokeapi.co/)
  """

  def project do
    [app: :pokerap,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: @description,
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"}]
  end

  defp package do
    [ name: :pokerap
      maintainers: ["LastContinue"],
      licenses: ["Apache 2.0"]
      links: %{"Github" => "https://github.com/lastcontinue/pokerap"}]
  end

end
