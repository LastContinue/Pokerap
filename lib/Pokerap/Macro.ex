defmodule Pokerap.Macro do
  @moduledoc """
  Collection of macros
  """
  require Pokerap.Url

  @doc """
  Creates a series of functions to be able to retrieve data from API endpoints

  Just about all of the functions in the top-level `Pokerap` module are created via this macro

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
        @doc """
        Returns a tuple containing request status, and data from `http://pokeapi.co/api/v2/#{unquote(ep)}`

        See [`http://www.pokeapi.co/docsv2/\##{unquote(ep)}`](http://www.pokeapi.co/docsv2/\##{unquote(ep)}) for details
        """
        def unquote(fn_name)(value) do
          Pokerap.Url.get_endpoint(unquote(ep),value)
        end
        @doc """
        Returns data from `http://pokeapi.co/api/v2/#{unquote(ep)}`

        This is the `!` version of `Pokerap.#{unquote(ep)}/1`. Will raise error if
        status does not return `:ok`

        See [`http://www.pokeapi.co/docsv2/\##{unquote(ep)}`](http://www.pokeapi.co/docsv2/\##{unquote(ep)}) for details
        """
        def unquote(fn_name!)(value) do
          Pokerap.Url.get_endpoint!(unquote(ep),value)
        end
      end
    end)
  end
end
