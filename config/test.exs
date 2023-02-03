import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :disi_tools, DisiToolsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OEiKHSLJzDy884zh/REGnIUg9+do1iaHI9YFCtpDqyDrkRv70uxOPH67vs+zVYlN",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
