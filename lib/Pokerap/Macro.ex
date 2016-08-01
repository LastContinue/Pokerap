defmodule Pokerap.Macro do
  @moduledoc """
  Collection of macros
  """
  require Pokerap.Url

  @doc """
    Creates a series of methods to be able to retrieve data from API endpoints

    Iterates over a list, such a [:pokemon, :types, "berries"]
    (atoms or strings, whatever is a better fit for the situation)
    and each item is formatted to a proper method name, and then
    the method is defined via macro.

    Each method takes "value" as an argument. This can be a string, int, or atom
    (see Pokerap.Url.get_endpoint).

    ! methods are also defined for each item in list.
  """
  defmacro make_endpoint_calls(names) do
    Enum.map(names, fn(name) ->
      fn_name = String.to_atom(name)
      fn_name! = String.to_atom("#{name}!")
      ep = String.replace("#{name}","_","-")
      quote do
        def unquote(fn_name)(value) do
          Pokerap.Url.get_endpoint(unquote(ep),value)
        end
        def unquote(fn_name!)(value) do
          Pokerap.Url.get_endpoint!(unquote(ep),value)
        end
      end
    end)
  end
end
