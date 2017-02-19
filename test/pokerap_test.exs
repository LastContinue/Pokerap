defmodule PokerapTest do
  use ExUnit.Case
  alias Pokerap.{Env}

  #Cheating a bit here, but these work at an integration level
  doctest Pokerap.Ez

  test "Defaults got set properly" do
    assert Env.timeout != nil
    assert Env.recv_timeout != nil
    assert Env.language == "en"

    assert is_integer(Env.timeout)
    assert is_integer(Env.recv_timeout)
  end

  test "Set Env can read from Application.put_env" do
    Application.put_env(:pokerap, :timeout, 100)
    assert Application.get_env(:pokerap, :timeout) == Env.timeout

    Application.put_env(:pokerap, :recv_timeout, 200)
    assert Application.get_env(:pokerap, :recv_timeout) == Env.recv_timeout

    Application.put_env(:pokerap, :language, "es")
    assert Application.get_env(:pokerap, :language) == Env.language
  end
end
