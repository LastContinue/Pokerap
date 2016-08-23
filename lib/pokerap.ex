defmodule Pokerap do
  @moduledoc """
  Pokerap: This is the main module that you'll find all of the methods to
  call resources from the Pokeapi http://pokeapi.co/
   """
 require Pokerap.Macro

 # Macro to define functions for generic endpoints
 # Clunky looking but really only way to get this into a macro
 Pokerap.Macro.make_endpoint_calls ["berry", "berry_firmness", "berry_flavor", "contest_type",
                  "contest_effect", "super_contest_effect", "encounter_method",
                  "encounter_condition", "encounter_condition_value", "evolution_chain",
                  "evolution_trigger", "generation", "pokedex", "version", "version_group",
                  "item", "item_attribute", "item_category", "item_fling_effect",
                  "item_pocket", "machine", "move", "move_ailment", "move_battle_style",
                  "move_category", "move_damage_class", "move_learn_method", "move_target",
                  "location", "location_area", "pal_park_area", "region", "ability",
                  "characteristic", "egg_group", "gender", "growth_rate", "nature",
                  "pokeathlon_stat", "pokemon", "pokemon_color", "pokemon_form",
                  "pokemon_habitat", "pokemon_shape", "pokemon_species", "stat",
                  "type", "language"]

  @doc """
  Repeatedly calls Pokeapi until it gets results! 頑張って!

  Pokeapi can still timeout despite fiddling with the timeout ENV var.
  This will keep trying until SOMETHING happens.

  Please don't use this in anything serious

  ##Example
  get_bidoof = fn -> Pokerap.pokemon(:bidoof) end
  {:ok, bidoof} = Pokerap.catch_em(get_bidoof)

  """
  def catch_em(function) do
    case function.() do
      {:ok, result} ->
        {:ok, result}
      {:error, :timeout} ->
        catch_em(function)
      {:error, error} ->
        {:error, error}
    end
  end

  def language do
    env_lang = Application.get_env(:pokerap, :language)
    if (env_lang), do: env_lang, else: "en"
  end
end
