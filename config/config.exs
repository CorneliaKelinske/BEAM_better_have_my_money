# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :beam_better_have_my_money,
  ecto_repos: [BEAMBetterHaveMyMoney.Repo]

config :ecto_shorts,
  repo: BEAMBetterHaveMyMoney.Repo,
  error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :beam_better_have_my_money, BEAMBetterHaveMyMoneyWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BEAMBetterHaveMyMoneyWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BEAMBetterHaveMyMoney.PubSub,
  live_view: [signing_salt: "zlhjvFcr"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :beam_better_have_my_money, BEAMBetterHaveMyMoney.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

api_key = System.get_env("API_KEY")

config :beam_better_have_my_money,
  load_from_system_env: true

config :beam_better_have_my_money,
  exchange_rate_server: "localhost:4001/query",
  currencies: [:CAD, :USD, :EUR],
  exchange_rate_getter: BEAMBetterHaveMyMoney.Exchanger.ExchangeRateGetter,
  global_ttl: 3_000,
  ttl_check_interval: 1_000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
