use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :app, AppWeb.Endpoint,
  secret_key_base: "jWLp5J+2pvV+wnFhtXdlX+TIyBHdJ/isAmt/0HDB2a91Ox7PFLyVrmI71hwXSInZ"

# Configure your database
config :app, App.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "app_prod",
  pool_size: 15
