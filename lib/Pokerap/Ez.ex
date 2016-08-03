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
    chain_species(name, fn(species) ->
      case Pokerap.Url.get_url(species["evolution_chain"]["url"]) do
        {:ok, evo} -> List.flatten(parse_evo(evo["chain"]))
        {:error, reason} -> {:error, reason}
        end
      end)
  end

  #chain another call after calling pokemon_species providing
  #that call resturns {:ok, _}
  defp chain_species(name, fn_x) do
      Pokerap.Url.chain_calls(name,&Pokerap.pokemon_species/1,fn_x)
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
    case chain_species(name, &parse_flavor_text/1) do
      {:error, reason} -> {:error, reason}
       flavor_texts -> {:ok, flavor_texts}
    end
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
    sprites = fn(pokemon) -> pokemon["sprites"] end
    Pokerap.Url.chain_calls(name,&Pokerap.pokemon/1,sprites)
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
    parse_types = fn(pokemon) ->
      Enum.map(pokemon["types"], &(&1["type"]["name"]))
    end
    Pokerap.Url.chain_calls(name,&Pokerap.pokemon/1,parse_types)
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
    parse_moves = fn(pokemon) ->
      Enum.map(pokemon["moves"], &(&1["move"]["name"]))
    end
    Pokerap.Url.chain_calls(name,&Pokerap.pokemon/1,parse_moves)
  end

  @doc """
  Returns simple list of ALL moves a Pokemon can have
  """
  def moves!(name) do
    Enum.map(Pokerap.pokemon!(name)["moves"], fn(x)-> x["move"]["name"] end)
  end

end
