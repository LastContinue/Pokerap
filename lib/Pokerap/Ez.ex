defmodule Pokerap.Ez do
  @moduledoc """
    Helper functions to make pokemon searching more intuitve
    "get what I mean" instead of the almost firehose-esk data from the API

  """

  #cleaner to move this out to its own funtion
  defp parse_evo(chain) do
      [chain["species"]["name"]|Enum.map(chain["evolves_to"], fn(x) -> parse_evo(x) end)]
  end

  @doc """
    Returns a "simple" evolution chain

    This resouce only takes the id of the chain, so you can't intuitively
    retreive data by pokemone name
  """
  def evolution(name) do
    with {:ok, species} <- Pokerap.pokemon_species(name),
         {:ok, evo} <- Pokerap.Url.get_url(species["evolution_chain"]["url"]),
         do: {:ok, List.flatten(parse_evo(evo["chain"]))}
  end

  #Parses flavor_texts, filters by language, returns map of "game version" => "text"
  defp parse_flavor_text(flavor_texts) do
    #this does not fee "Elixir-y"
    env_lang = Application.get_env(:pokerap, :language)
    language = if (env_lang), do: env_lang, else: "en"
    filter_lang = fn(x) -> x["language"]["name"] == language end
    Enum.filter(flavor_texts["flavor_text_entries"], filter_lang)
    |> Enum.reduce(%{}, fn(entry, acc) ->
      Map.merge(acc, %{entry["version"]["name"] => entry["flavor_text"]})
    end)
  end

  @doc """
  Gets map of pokedex style descriptions.
  """
  def flavor_text(name) do
    with {:ok, species} <- Pokerap.pokemon_species(name),
         do: {:ok, parse_flavor_text(species)}
  end

  @doc """
  Gets map of pokedex style descriptions.
  """
  def flavor_text!(name) do
    parse_flavor_text(Pokerap.pokemon_species!(name))
  end

  #TODO: Maybe expand this to offer images of all varieites and forms?
  @doc """
  Gets map of images.
  """
  def images(name) do
    with {:ok, pokemon} <- Pokerap.pokemon(name),
          do: {:ok, pokemon["sprites"]}
  end

  @doc """
  Gets map of images.
  """
  def images!(name) do
    Pokerap.pokemon!(name)["sprites"]
  end

  @doc """
  Gets pokedex style list of types per pokemon
  """
  def types(name) do
    with {:ok, pokemon} <- Pokerap.pokemon(name),
         types <- Enum.map(pokemon["types"], &(&1["type"]["name"])),
         do: {:ok, types}
  end

  @doc """
  Gets pokedex style list of types per pokemon
  """
  def types!(name) do
    Pokerap.pokemon!(name)["types"]
    |> Enum.map(&(&1["type"]["name"]))
  end

  #TODO: This list can be really long and confusing, so need to find a way to filter it
  @doc """
  Returns simple list of ALL moves a Pokemon can have
  """
  def moves(name) do
    with {:ok, pokemon} <- Pokerap.pokemon(name),
         moves <- Enum.map(pokemon["moves"], &(&1["move"]["name"])),
         do: {:ok, moves}
   end

  @doc """
  Returns simple list of ALL moves a Pokemon can have
  """
  def moves!(name) do
    Enum.map(Pokerap.pokemon!(name)["moves"], fn(x)-> x["move"]["name"] end)
  end

end
