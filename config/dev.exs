use Mix.Config

config :pokerap, language: System.get_env("POKERAP_LANGUAGE")
config :pokerap, timeout: System.get_env("POKERAP_RECV_TIMEOUT")
config :pokerap, recv_timeout: System.get_env("POKERAP_RECV_TIMEOUT")
