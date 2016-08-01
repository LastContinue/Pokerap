# Pokerap

Wrapper library for the Pokeapi (http://pokeapi.co/)

All resources are available via `Pokerap.{{resource_name}}(value)`. `!` versions exist
for all API resource functions (such as `Pokerap.pokemon("pikachu")` and `Pokerap.pokemon!("pikachu")`)

There is a lot of data in this API, so I wrote some helpers!

Convenience functions are found under `Pokerap.Ez` (so you can get to the stuff you just want to know)

For example:
You'll find this
`Pokerap.Ez.types!(:bulbasaur)`
easier to grok than
`Pokerap.pokemon!(:bulbasaur)["types"]`

ENV settings:

You can set the default language (currently "en") for flavor texts.
See http://pokeapi.co/api/v2/language/ for full list.

Be advised that not all flavor_texts have listings for
all languages, so if you're getting `{:ok, %{}}` for every Pokemon, you might try
switching to "ja" or "ja-kanji" to double check before filing an issue.

Also configurable is the timeout for HTTPoison (I found the default resulted in many timeouts)
```
config :pokerap, language: :en
config :pokerap, timeout: 10000
```

**"I'm still getting a bunch of timeouts!"**
There's a toy function I wrote(`Pokerap.catch_em\1`) that will try to run your request
until it get something back. This is something you shouldn't use all the time, but
can be useful for debugging
```
get_bidoof = fn -> Pokerap.pokemon(:bidoof) end
{:ok, bidoof} = Pokerap.catch_em(get_bidoof)
```

**"Hey, how come all of the map keys are strings, and not atoms! That's not very Elixir-y!"**

It's a feature of HTTPoison. You can rekey if you like (https://github.com/edgurgel/httpoison#wrapping-httpoisonbase)

### What's next:
* Documentation. I feel what is currently in place is the bare minimum
* Examples
* Testing. This will require a bunch of "mocking" against HTTPoison, so I'm not really looking forward to it
* Possibly look into returning structs for some EZ functions. Maybe even a "Pokedex" style struct that matches entries from the games/animes/mangas (If I can remember what those look like)
* logging

## Installation
(Not in Hex yet. This is boilerplate)
If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `pokerap` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:pokerap, "~> 0.1.0"}]
    end
    ```

  2. Ensure `pokerap` is started before your application:

    ```elixir
    def application do
      [applications: [:pokerap]]
    end
    ```
