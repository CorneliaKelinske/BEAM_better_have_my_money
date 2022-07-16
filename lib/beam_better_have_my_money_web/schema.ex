defmodule BEAMBetterHaveMyMoneyWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias BEAMBetterHaveMyMoneyWeb.Middlewares.HandleErrors

  import_types BEAMBetterHaveMyMoneyWeb.Types.Currency
  import_types BEAMBetterHaveMyMoneyWeb.Types.ExchangeRate
  import_types BEAMBetterHaveMyMoneyWeb.Types.User
  import_types BEAMBetterHaveMyMoneyWeb.Types.Wallet
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Queries.User

  query do
    import_fields :user_queries
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(BEAMBetterHaveMyMoney.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), BEAMBetterHaveMyMoney.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, _) do
    middleware ++ [HandleErrors]
  end
end
