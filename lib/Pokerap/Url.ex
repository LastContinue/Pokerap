defmodule Pokerap.Url do
  @moduledoc """
  Holds utility functions to actually make HTTP calls
  """

  defp httpoison_get() do
    timeout = String.to_integer(Application.get_env(:pokerap, :timeout))
    recv_timeout = String.to_integer(Application.get_env(:pokerap, :recv_timeout))
    timeouts = fn
      (timeout, nil) -> [timeout: timeout]
      (nil, recv_timeout) -> [recv_timeout: recv_timeout]
      (timeout, recv_timeout) -> [timeout: timeout, recv_timeout: recv_timeout]
    end
    fn(url) -> HTTPoison.get(url, [], timeouts.(timeout,recv_timeout)) end
  end

  # Calls HTTPoison to actually get resources from API
  def get_url(url) do
    case httpoison_get.(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, status_code}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  # Calls HTTPoison to actually get resources from API, ! version
  def get_url!(url) do
    case httpoison_get.(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        raise status_code
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason
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
  Gets data from remote using endpoint name and value to query.
  """
  def get_endpoint(endpoint, value) do
    get_url(build_url(endpoint,value))
  end

  @doc """
  Gets data from remote using endpoint name and value to query.
  """
  def get_endpoint!(endpoint, value) do
    get_url!(build_url(endpoint,value))
  end

end
