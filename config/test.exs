import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :beam_better_have_my_money, BEAMBetterHaveMyMoney.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "beam_better_have_my_money_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :beam_better_have_my_money, BEAMBetterHaveMyMoneyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Oe6PGv+N8bcMyZu2yHbYGO64zpZ3KFqTLop8rbXMgzs2Hgj6gho5aMMNUO86XHh9",
  server: false

# In test we don't send emails.
config :beam_better_have_my_money, BEAMBetterHaveMyMoney.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :beam_better_have_my_money,
  exchange_rate_getter: BEAMBetterHaveMyMoney.ExchangeRateGetterStub,
  global_ttl: 50,
  ttl_check_interval: 10,
  exchange_rate_cache: :test_cache,
  env: :test
