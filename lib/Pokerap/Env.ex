defmodule Pokerap.Env do
  @moduledoc """
  Place to hold functions that expose Application env_vars.
  """
  @doc """
  Returns value for `timeout` that is used for HTTPoison. Defaults to 8000
  """
  def timeout() do
    # Application.get_env/3 only returns default when env is not defined, not nil
    # nil can happen when Application env tries to call a System env that is not defined
    process_env(Application.get_env(:pokerap, :timeout), 8000)
  end

  @doc """
  Returns value for `recv_timeout` that is used for HTTPoison. Defaults to 5000
  """
  def recv_timeout() do
    # Application.get_env/3 only returns default when env is not defined, not nil
    # nil can happen when Application env tries to call a System env that is not defined
    process_env(Application.get_env(:pokerap, :recv_timeout), 5000)
  end

  defp process_env(env, default) do
    case env do
      nil -> default
      value when is_bitstring(value)-> Integer.parse(value) |> elem(0)
      value -> value
    end
  end

  @doc """
  gets default language from config. Uses "en" if no default
  specified
  """
  def language() do
    Application.get_env(:pokerap, :language) || "en"
  end

end
