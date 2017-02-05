defmodule Pokerap.Mixfile do
  use Mix.Project

  @description """
  Wrapper library for the Pokeapi [http://pokeapi.co](http://pokeapi.co/)
  """

  def project do
    [app: :pokerap,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: @description,
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),

     #Docs
     name: "Pokerap",
     source_url: "https://github.com/lastcontinue/pokerap",
     homepage_url: "https://github.com/lastcontinue/pokerap",
     docs: [ main: "readme",
       extras: ["README.md"]]]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.0"},
     {:poison, "~> 3.0"},
     {:ex_doc, "~> 0.14", only: :dev}]
  end

  defp package do
    [ name: :pokerap,
      maintainers: ["LastContinue"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/lastcontinue/pokerap"}]
  end

end
