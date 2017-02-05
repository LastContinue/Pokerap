use Mix.Config

#These are values that are used currently. You can set them several different ways
#depending on your usage.

config :pokerap, language: System.get_env("POKERAP_LANGUAGE")
config :pokerap, timeout: System.get_env("POKERAP_RECV_TIMEOUT")
config :pokerap, recv_timeout: System.get_env("POKERAP_RECV_TIMEOUT")
