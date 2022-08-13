defmodule BEAMBetterHaveMyMoneyWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias BEAMBetterHaveMyMoneyWeb.Middlewares.HandleErrors

  import_types BEAMBetterHaveMyMoneyWeb.Types.Currency
  import_types BEAMBetterHaveMyMoneyWeb.Types.ExchangeRate
  import_types BEAMBetterHaveMyMoneyWeb.Types.TotalWorth
  import_types BEAMBetterHaveMyMoneyWeb.Types.TotalWorthChange
  import_types BEAMBetterHaveMyMoneyWeb.Types.Transaction
  import_types BEAMBetterHaveMyMoneyWeb.Types.User
  import_types BEAMBetterHaveMyMoneyWeb.Types.Wallet
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Queries.ExchangeRate
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Queries.TotalWorth
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Queries.User
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Queries.Wallet
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Mutations.User
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Mutations.Wallet
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.ExchangeRate
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.TotalWorth
  import_types BEAMBetterHaveMyMoneyWeb.Schema.Subscriptions.User

  query do
    import_fields :exchange_rate_queries
    import_fields :total_worth_queries
    import_fields :user_queries
    import_fields :wallet_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :wallet_mutations
  end

  subscription do
    import_fields :exchange_rate_subscriptions
    import_fields :total_worth_subscriptions
    import_fields :user_subscriptions
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(BEAMBetterHaveMyMoney.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), BEAMBetterHaveMyMoney.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _, %{identifier: identifier})
      when identifier in [:query, :subscription, :mutation] do
    middleware ++ [HandleErrors]
  end

  def middleware(middleware, _, _) do
    middleware
  end
end
