# LiveFeedback

To start your Phoenix server:

-   Run `mix setup` to install and setup dependencies
-   Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

-   Official website: https://www.phoenixframework.org/
-   Guides: https://hexdocs.pm/phoenix/overview.html
-   Docs: https://hexdocs.pm/phoenix
-   Forum: https://elixirforum.com/c/phoenix-forum
-   Source: https://github.com/phoenixframework/phoenix

## Development Setup

Add a .env.exs file in the config folder.

You will need to then add
System.put_env("EMAIL", "YOUR DESIRED EMAIL")

## NEW DB INSTRUCTIONS (ONLY FOLLOW THIS ONCE)

To get the new database seeded properly do the following:
-   Make sure your branch is up-to-date with dev (this should be done already if you see this lol)
-   Run `mix ecto.drop` to drop the current Repo and database. THIS WILL ERASE ANY EXISTING DATA YOU PUT IN THE DB SO MAKE SURE YOU ARE OKAY WITH THAT
-   Run `mix setup` and all migrations will be run, the schemas will be compiled, and the database will be seeded.
-   DONE.

You can run `mix setup` as needed. Any changes or data you add in will be unaffected by this.
