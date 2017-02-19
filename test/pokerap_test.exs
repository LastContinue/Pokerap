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
end
