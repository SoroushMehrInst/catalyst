# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :catalyst,
  ecto_repos: [Catalyst.Repo]

# Configures the endpoint
config :catalyst, Catalyst.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bQSdmFYP7NA0H+c6gvkXA53MYTany0U3WbD98S46otz+wZ3jWCBARu0V8xm8RjfS",
  render_errors: [view: Catalyst.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Catalyst.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_admin,
  repo: Catalyst.Repo,
  module: Catalyst,    # MyProject.Web for phoenix >= 1.3.0-rc
  modules: [
    Catalyst.ExAdmin.Dashboard,
    Catalyst.ExAdmin.Applications,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}
