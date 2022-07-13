defmodule BEAMBetterHaveMyMoneyWeb.Router do
  use BEAMBetterHaveMyMoneyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: BEAMBetterHaveMyMoneyWeb.Schema

    if Mix.env() === :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: BEAMBetterHaveMyMoneyWeb.Schema,
        socket: BEAMBetterHaveMyMoneyWeb.UserSocket,
        interface: :playground
    end
  end
end
