defmodule Pokerap.Env do
  @moduledoc """
    Place to hold functions that expose Application env_vars.
  """
  @doc """
  Returns value of `Application.get_env(:pokerap, :timeout, 8000)`
  """
  def timeout() do
    Application.get_env(:pokerap, :timeout, 8000)
    |> Integer.parse
    |> elem(0)
  end

  @doc """
  Returns value of `Application.get_env(:pokerap, :recv_timeout, 5000)`
  """
  def recv_timeout() do
    Application.get_env(:pokerap, :recv_timeout, 5000)
    |> Integer.parse
    |> elem(0)
  end

  @doc """
  gets default language from config. Uses "en" if no default
  specified
  """
  def language() do
    Application.get_env(:pokerap, :language, "en")
  end

end
