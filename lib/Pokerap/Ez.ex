defmodule Pokerap.Ez do
  @moduledoc """
  Helper functions to make pokemon searching more intuitve
  "get what I mean" instead of the almost firehose-esk data from the API

  """
  alias Pokerap.Env, as: Env

  #cleaner to move this out to its own funtion
  defp parse_evo(chain) do
    [chain["species"]["name"]|Enum.map(chain["evolves_to"], fn(x) -> parse_evo(x) end)]
  end

  @doc ~S"""
  Returns a tuple containg status, and a "simple" evolution chain in list form

  This is a simpilifed combination of the chain `/pokemon-species`  into `/evolution-chain`.
  `/evolution-chain` only takes in a numerical id of the evolution chain, that you can only get
  from `/pokemon-species` (What? You don't know  that `Garbodor's` evolution chain ID is 290 ?), so having the ability to just pass in
  a string for name is much easier.

  ## Example

      iex> Pokerap.Ez.evolution("garbodor")
      {:ok, ["trubbish", ["garbodor"]]}

  """
  def evolution(name) do
    with {:ok, species} <- Pokerap.pokemon_species(name),
         {:ok, evo} <- Pokerap.Url.get_url(species["evolution_chain"]["url"]),
      do: {:ok, parse_evo(evo["chain"])}
  end

  #Parses flavor_texts, filters by language, returns map of "game version" => "text"
  defp parse_flavor_text(flavor_texts) do
    #this does not fee "Elixir-y"
    filter_lang = fn(x) -> x["language"]["name"] == Env.language end
    Enum.filter(flavor_texts["flavor_text_entries"], filter_lang)
    |> Enum.reduce(%{}, fn(entry, acc) ->
      Map.merge(acc, %{entry["version"]["name"] => entry["flavor_text"]})
    end)
  end

  @doc ~S"""
  Returns a tuple containing request status, and map of flavor texts.

  This data is found inside of the `/pokemon` endpoint (`Pokerap.pokemon/1`)
  but is nested somewhat deeply.

  Will return in the language set in config under `config :pokerap, language:`. Defaults to "en".
  See [Readme](readme.html#env-settings) for more details on this function.

  ## Example

      iex> Pokerap.Ez.flavor_text("bidoof")
      {:ok,
      %{"alpha-sapphire" => "It constantly gnaws on logs and rocks to whittle\ndown its front teeth. It nests alongside water.",
      "black" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "black-2" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "diamond" => "With nerves of steel, nothing can\nperturb it. It is more agile and\nactive than it appears.",
      "heartgold" => "It lives in groups by the water. \nIt chews up boulders and trees\naround its nest with its incisors.",
      "omega-ruby" => "With nerves of steel, nothing can perturb it. It is\nmore agile and active than it appears.",
      "pearl" => "It constantly gnaws on logs and\nrocks to whittle down its front\nteeth. It nests alongside water.",
      "platinum" => "A comparison revealed that\nBIDOOF’s front teeth grow at\nthe same rate as RATTATA’s.",
      "soulsilver" => "It lives in groups by the water. \nIt chews up boulders and trees\naround its nest with its incisors.",
      "white" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "white-2" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "x" => "With nerves of steel, nothing can perturb it. It is\nmore agile and active than it appears.",
      "y" => "It constantly gnaws on logs and rocks to whittle\ndown its front teeth. It nests alongside water."}}

  """
  def flavor_text(name) do
    with {:ok, species} <- Pokerap.pokemon_species(name),
      do: {:ok, parse_flavor_text(species)}
  end

  @doc ~S"""
  Gets map of pokedex style descriptions.

  Returns map of flavor texts. Raises exceptions upon error. `!` version of `Pokerap.Ez.flavor_text/1`

  ## Example

      iex> Pokerap.Ez.flavor_text!("bidoof")
      %{"alpha-sapphire" => "It constantly gnaws on logs and rocks to whittle\ndown its front teeth. It nests alongside water.",
      "black" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "black-2" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "diamond" => "With nerves of steel, nothing can\nperturb it. It is more agile and\nactive than it appears.",
      "heartgold" => "It lives in groups by the water. \nIt chews up boulders and trees\naround its nest with its incisors.",
      "omega-ruby" => "With nerves of steel, nothing can perturb it. It is\nmore agile and active than it appears.",
      "pearl" => "It constantly gnaws on logs and\nrocks to whittle down its front\nteeth. It nests alongside water.",
      "platinum" => "A comparison revealed that\nBIDOOF’s front teeth grow at\nthe same rate as RATTATA’s.",
      "soulsilver" => "It lives in groups by the water. \nIt chews up boulders and trees\naround its nest with its incisors.",
      "white" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "white-2" => "A comparison revealed that\nBidoof’s front teeth grow at\nthe same rate as Rattata’s.",
      "x" => "With nerves of steel, nothing can perturb it. It is\nmore agile and active than it appears.",
      "y" => "It constantly gnaws on logs and rocks to whittle\ndown its front teeth. It nests alongside water."}

  """
  def flavor_text!(name) do
    parse_flavor_text(Pokerap.pokemon_species!(name))
  end

  @doc ~S"""
  Returns a tuple containing request status, and map of images.

  This data is found inside of the `/pokemon` endpoint (`Pokerap.pokemon/1`)
  but is nested somewhat deeply.

  ## Example
      iex> Pokerap.Ez.images("poliwhirl")
      {:ok,
      %{"back_default" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/61.png",
      "back_female" => nil,
      "back_shiny" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/61.png",
      "back_shiny_female" => nil,
      "front_default" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/61.png",
      "front_female" => nil,
      "front_shiny" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/61.png",
      "front_shiny_female" => nil}}

  """
  def images(name) do
    with {:ok, pokemon} <- Pokerap.pokemon(name),
      do: {:ok, pokemon["sprites"]}
  end

  @doc ~S"""
  Gets map of images.

  Returns map of images. Raises exceptions upon error.
  `!` version of `Pokerap.Ez.images/1`

  ## Example
      iex> Pokerap.Ez.images!("poliwhirl")
      %{"back_default" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/61.png",
      "back_female" => nil,
      "back_shiny" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/61.png",
      "back_shiny_female" => nil,
      "front_default" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/61.png",
      "front_female" => nil,
      "front_shiny" => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/61.png",
      "front_shiny_female" => nil}

  """
  def images!(name) do
    Pokerap.pokemon!(name)["sprites"]
  end

  @doc ~S"""
  Returns a tuple containing request status, and list of Pokemon types.

  This data is found inside of the `/pokemon` endpoint (`Pokerap.pokemon/1`)
  but is nested somewhat deeply.

  ## Example

      iex(1)> Pokerap.Ez.types("rotom")
      {:ok, ["ghost", "electric"]}

  """
  def types(name) do
    with {:ok, pokemon} <- Pokerap.pokemon(name),
         types <- Enum.map(pokemon["types"], &(&1["type"]["name"])),
      do: {:ok, types}
  end

  @doc ~S"""
  Gets a list of types per pokemon

  Returns list. Raises exceptions upon error.
  `!` version of `Pokerap.Ez.types/1`

  ## Example

      iex> Pokerap.Ez.types!("rotom")
      ["ghost", "electric"]

  """
  def types!(name) do
    Pokerap.pokemon!(name)["types"]
    |> Enum.map(&(&1["type"]["name"]))
  end

  @doc ~S"""
  Returns a tuple containing request status, and list of possible moves a Pokemon **can** have/learn.

  Returns "simple" list of ALL moves a Pokemon **can** have/learn

  ## Example

      iex> Pokerap.Ez.moves("caterpie")
      {:ok, ["tackle", "string-shot", "snore", "bug-bite", "electroweb"]}

  Be advised, Some pokemon have very long move sets
  """
  def moves(name) do
    with {:ok, pokemon} <- Pokerap.pokemon(name),
         moves <- Enum.map(pokemon["moves"], &(&1["move"]["name"])),
      do: {:ok, moves}
  end

  @doc ~S"""
  Returns a list of possible moves a Pokemon can have/learn.

  Returns "simple" list of ALL moves a Pokemon **can** have/learn.

  Raises exceptions upon error. `!` version of `Pokerap.Ez.moves/1`

  ## Example

      iex> Pokerap.Ez.moves!("caterpie")
      ["tackle", "string-shot", "snore", "bug-bite", "electroweb"]

  Be advised, Some pokemon have very long move sets
  """
  def moves!(name) do
    Enum.map(Pokerap.pokemon!(name)["moves"], fn(x)-> x["move"]["name"] end)
  end

end
