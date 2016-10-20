defmodule Pokerap.Url do
  @moduledoc """
  Holds utility functions to actually make HTTP calls
  """

  alias Pokerap.Env, as: Env

  #Builds option array (currently only timeouts) for HTTPoison
  defp get_options() do
    [timeout: Env.timeout, recv_timeout: Env.recv_timeout]
  end

  @doc """
  Makes call to Httpoision and wraps results in tuple.

  Make sure `url` has a trailing slash.

  This is an intermediary step in `Pokerap.Url.get_endpoint/2`, and only
  meant to be used when you can _only_ get a full Url (such as `evolution-chain`
  url from `pokemon-species`) See `Pokerap.Url.get_endpoint/2` for full details.
  """
  def get_url(url) do
    case HTTPoison.get(url, [], get_options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, status_code}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Makes call to Httpoision and returns results.

  Make sure `url` has a trailing slash. Raises exeptions upon error. ! version
  of `Pokerap.Url.get_url`.

  This is an intermediary step in `Pokerap.Url.get_endpoint!/2`, and only
  meant to be used when you can _only_ get a full Url (such as `evolution-chain`
  url from `pokemon-species`) See `Pokerap.Url.get_endpoint!/2` for full details.
  """
  def get_url!(url) do
    case get_url(url) do
      {:ok, body} -> body
      {:error, status_code} when is_integer(status_code) ->
        raise Integer.to_string(status_code)
      {_, error} -> raise error
    end
  end

  # Builds URL string based on params.
  defp build_url(endpoint, value) do
    downcase?= fn
      value when is_bitstring(value) -> String.downcase(value)
      value when is_integer(value) -> Integer.to_string(value)
      value when is_atom(value) -> Atom.to_string(value)
    end
    "http://pokeapi.co/api/v2/#{endpoint}/#{downcase?.(value)}/"
  end

  @doc """
  Calls HTTPoison after assembling URL to get resources from API. Returns tuple of request status,
  and data arranged in different ways depending on endpoint.

  Takes endpoint and value, constructs URL, then makes HTTPoison request.

  ## Example
  ```
  iex(1)> Pokerap.Url.get_endpoint("berry","cheri")
  {:ok, %{"firmness" => %{"name" => "soft",
  "url" => "http://pokeapi.co/api/v2/berry-firmness/2/"},
  "flavors" => [%{"flavor" => %{"name" => "spicy",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/1/"}, "potency" => 10},
  %{"flavor" => %{"name" => "dry",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/2/"}, "potency" => 0},
  %{"flavor" => %{"name" => "sweet",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/3/"}, "potency" => 0},
  %{"flavor" => %{"name" => "bitter",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/4/"}, "potency" => 0},
  %{"flavor" => %{"name" => "sour",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/5/"}, "potency" => 0}],
  "growth_time" => 3, "id" => 1,
  "item" => %{"name" => "cheri-berry",
  "url" => "http://pokeapi.co/api/v2/item/126/"}, "max_harvest" => 5,
  "name" => "cheri", "natural_gift_power" => 60,
  "natural_gift_type" => %{"name" => "fire",
  "url" => "http://pokeapi.co/api/v2/type/10/"}, "size" => 20,
  "smoothness" => 25, "soil_dryness" => 15}}
  ```
  """
  def get_endpoint(endpoint, value) do
    get_url(build_url(endpoint,value))
  end

  @doc """
  Calls HTTPoison after assembling URL get resources from API. Returns data arranged in different ways depending on endpoint.

  Takes endpoint and value, constructs URL, then makes HTTPoison request.

  Raises exceptions upon error. `!` version of `Pokerap.Url.get_endpoint/1`

  ## Example
  ```
  iex(1)> Pokerap.Url.get_endpoint!("berry","cheri")
  %{"firmness" => %{"name" => "soft",
  "url" => "http://pokeapi.co/api/v2/berry-firmness/2/"},
  "flavors" => [%{"flavor" => %{"name" => "spicy",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/1/"}, "potency" => 10},
  %{"flavor" => %{"name" => "dry",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/2/"}, "potency" => 0},
  %{"flavor" => %{"name" => "sweet",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/3/"}, "potency" => 0},
  %{"flavor" => %{"name" => "bitter",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/4/"}, "potency" => 0},
  %{"flavor" => %{"name" => "sour",
  "url" => "http://pokeapi.co/api/v2/berry-flavor/5/"}, "potency" => 0}],
  "growth_time" => 3, "id" => 1,
  "item" => %{"name" => "cheri-berry",
  "url" => "http://pokeapi.co/api/v2/item/126/"}, "max_harvest" => 5,
  "name" => "cheri", "natural_gift_power" => 60,
  "natural_gift_type" => %{"name" => "fire",
  "url" => "http://pokeapi.co/api/v2/type/10/"}, "size" => 20,
  "smoothness" => 25, "soil_dryness" => 15}
  ```
  """
  def get_endpoint!(endpoint, value) do
    get_url!(build_url(endpoint,value))
  end

end
