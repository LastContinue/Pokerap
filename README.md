![Pokerap drop](https://cloud.githubusercontent.com/assets/20746446/19466862/6f4aa2d0-94d3-11e6-94be-a3df4f22e83d.png)

# Pokerap

Elixir wrapper library for the Pokeapi [http://pokeapi.co/](http://pokeapi.co/)

[Hex Docs](https://hexdocs.pm/pokerap/readme.html)

## Installation

  1. Add `pokerap` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:pokerap, "~> 0.1.1"}]
    end
    ```

  2. Ensure `pokerap` is started before your application: (this is necessary for HTTPoison to start)

    ```elixir
    def application do
      [applications: [:pokerap]]
    end
    ```

## Usage
Every resource under [http://pokeapi.co/docsv2/#resource-lists](http://pokeapi.co/docsv2/#resource-lists) is mapped to the `Pokerap` module with a function that returns a pattern matchable tuple, as well as a ! version that only returns data.

	{:ok, pikachu} = Pokerap.pokemon(:pikachu)
	pikatwo = Pokerap.pokemon!(:pikachu)

Resources that have a hypen in the name such as `/api/v2/pokemon-species/{id or name}` have been renamed so they are valid Elixir

	Pokerap.pokemon_species(:dragonite)

Any function for a resource under [http://pokeapi.co/docsv2/#resource-lists](http://pokeapi.co/docsv2/#resource-lists) that can take `{id or name}` can take strings, atoms or integers.

	{:ok, eevee} = Pokerap.pokemon(:eevee)
	{:ok, jolteon} = Pokerap.pokemon("jolteon")
	{:ok, espeon} = Pokerap.pokemon(196)

Any function for a resource under [http://pokeapi.co/docsv2/#resource-lists](http://pokeapi.co/docsv2/#resource-lists) that can **only** take `{id}` can take integers (at the moment. Thinking of doing this so it can take URL's as well. Building guards into this maybe a good idea
for the future.)

	{:ok, eevee_evolution_chain} = Pokerap.evolution_chain(67)
	{:error, 500} = Pokerap.evolution_chain(:cubone)

I _highly_ recommend you play around with this in IEX because the amount of data, and how it's organized, can
be overwhelming.

### Convenience functions
Since there is a lot of data in this API, I wrote some helpers!

Convenience functions are found under `Pokerap.Ez` (so you can get to the stuff you just want to know)

For example:

	iex(1)> Pokerap.pokemon!(:abomasnow)["types"]
	[%{"slot" => 2,
		"type" => %{"name" => "ice", "url" => "http://pokeapi.co/api/v2/type/15/"}},
 	%{"slot" => 1,
   		"type" => %{"name" => "grass", "url" => "http://pokeapi.co/api/v2/type/12/"}}]

Would take a bit to parse, however

	iex(2)> Pokerap.Ez.types!(:abomasnow)
	["ice", "grass"]

No problem! (Although maybe a bit too simplified...this may get improved upon)

Lets try another one! What if we want to see how a Pokemon can evolve?

	iex(1)> Pokerap.pokemon_species!(:pikachu)["evolution_chain"]
	%{"url" => "http://pokeapi.co/api/v2/evolution-chain/10/"}
	iex(2)> Pokerap.evolution_chain(10)
	{:ok,
	 %{"baby_trigger_item" => nil,
	   "chain" => %{"evolution_details" => [],
	     "evolves_to" => [%{"evolution_details" => [%{"gender" => nil,
	           "held_item" => nil, "item" => nil, "known_move" => nil,
	           "known_move_type" => nil, "location" => nil, "min_affection" => nil,
	           "min_beauty" => nil, "min_happiness" => 220, "min_level" => nil,
	           "needs_overworld_rain" => false, "party_species" => nil,
	           "party_type" => nil, "relative_physical_stats" => nil,
	           "time_of_day" => "", "trade_species" => nil,
	           "trigger" => %{"name" => "level-up",
	             "url" => "http://pokeapi.co/api/v2/evolution-trigger/1/"},
	           "turn_upside_down" => false}],
	        "evolves_to" => [%{"evolution_details" => [%{"gender" => nil,
	              "held_item" => nil,
	              "item" => %{"name" => "thunder-stone",
	                "url" => "http://pokeapi.co/api/v2/item/83/"},
	              "known_move" => nil, "known_move_type" => nil, "location" => nil,
	              "min_affection" => nil, "min_beauty" => nil,
	              "min_happiness" => nil, "min_level" => nil,
	              "needs_overworld_rain" => false, "party_species" => nil,
	              "party_type" => nil, "relative_physical_stats" => nil,
	              "time_of_day" => "", "trade_species" => nil,
	              "trigger" => %{"name" => "use-item",
	                "url" => "http://pokeapi.co/api/v2/evolution-trigger/3/"},
	              "turn_upside_down" => false}], "evolves_to" => [],
	           "is_baby" => false,
	           "species" => %{"name" => "raichu",
	             "url" => "http://pokeapi.co/api/v2/pokemon-species/26/"}}],
	        "is_baby" => false,
	        "species" => %{"name" => "pikachu",
	          "url" => "http://pokeapi.co/api/v2/pokemon-species/25/"}}],
	     "is_baby" => true,
	     "species" => %{"name" => "pichu",
	       "url" => "http://pokeapi.co/api/v2/pokemon-species/172/"}}, "id" => 10}}
Whoa! Pretty chewy. The Thunderstone adds a bit, but still something to sift through.

Lets do this instead

    iex(5)> Pokerap.Ez.evolution(:pikachu)
    {:ok, ["pichu", ["pikachu", ["raichu"]]]}

That's better! You'll notice that each (nested) list is an evolution branch, so Pokemon with branched evolutions can be picked out better.

    iex(2)> Pokerap.Ez.evolution("slowpoke")
    {:ok, ["slowpoke", ["slowbro"], ["slowking"]]}

Slowpoke can become _either_ Slobro, _or_ Slowking, so you see how the lists are nested here.

And just for good measure:  

    iex(6)> Pokerap.Ez.evolution("poliwag")
    {:ok, ["poliwag", ["poliwhirl", ["poliwrath"], ["politoed"]]]}    
Once a Poliwag becomes a Poliwhirl, it can become _either_ a Poliwrath, _or_ a Politoed (well...not in Pokemon Go... yet...), but again, you can see the nesting.

`/lib/Pokerap.Ez.ex` is pretty short, so you can browse through there to see what all you can do.

**Try 'em all!**
## ENV/Config Settings
All of these have defaults so they are **optional**.

| Env | Desc | Format | Default |
|-----|------|--------|---------|
| `:pokerap, :timeout`  | timeout to send request( I think? )  | integer (in milliseconds)  |  8000 |
| `:pokerap, :recv_timeout` | timeout to receive response   | integer (in milliseconds)  | 5000  |
| `:pokerap, :language` | default language  | string  | "en"  |

Can be set such as:

	Application.put_env(:pokerap, :language, "es")

or in Config.exs

    config :pokerap, language: "es"

or if you like ENV settings (how I would do it) you can also do  

    POKERAP_LANGUAGE=en  
    POKERAP_TIMEOUT=10000
    POKERAP_RECV_TIMEOUT=8000

In a file (I suggest `.env`) and then make sure you run `source .env` before you start your app (or built it into your login script, or something. Lots of flexibility here.)


See `/lib/Pokerap/Env.ex` for how this works if you're curious. I got the idea from
[http://blog.danielberkompas.com/elixir/2015/03/21/manage-env-vars-in-elixir.html](http://blog.danielberkompas.com/elixir/2015/03/21/manage-env-vars-in-elixir.html) 🍺

### Language Support
See [http://pokeapi.co/api/v2/language/](http://pokeapi.co/api/v2/language/) for full list of supported languages.

Be advised that not all flavor texts have listings for
all languages, so if you're getting `{:ok, %{}}` for every Pokemon, you might try
switching to "ja" or "ja-kanji" to double check before filing an issue.

## Testing  

Okay, this needs quite a bit of work, **however** , there are doc tests for the `Ez` module that work at an "integration" level with the Pokeapi.co API. This isn't ideal, but you can at least see if you've broken something big while you've been hacking away. Since most of the other methods are done via macro, I did most of my hacking with the `Ez` module, so thusly why I wanted to be able to test at least some aspect of it.

`mix test` will run these. See `config/test.exs` for note about language setting in test.

## Anticipated Questions:

**"Hey, how come all of the map keys are strings, and not atoms! That's not very Elixir-y!"**

It's a feature of HTTPoison. You can rekey if you like [https://github.com/edgurgel/httpoison#wrapping-httpoisonbase](https://github.com/edgurgel/httpoison#wrapping-httpoisonbase)

## What's next?
* Possibly look into returning structs for some EZ functions. Maybe even a "Pokedex" style struct that matches entries from the games/anime/manga (If I can remember what those look like)
* logging
* better use of multiple language options on resources where it makes sense
