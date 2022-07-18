defmodule BEAMBetterHaveMyMoney.Config do
  @moduledoc """
  Fetches the environmental variables from the config.exs file
  """
  @app :beam_better_have_my_money

  @spec currencies :: [String.t()]
  def currencies do
    Application.fetch_env!(@app, :currencies)
  end

  @spec exchange_rate_server :: String.t()
  def exchange_rate_server do
    Application.fetch_env!(@app, :exchange_rate_server)
  end

  @spec exchange_rate_getter :: atom
  def exchange_rate_getter do
    Application.fetch_env!(@app, :exchange_rate_getter)
  end

  @spec global_ttl :: non_neg_integer()
  def global_ttl do
    Application.fetch_env!(@app, :global_ttl)
  end

  @spec ttl_check_interval :: non_neg_integer()
  def ttl_check_interval do
    Application.fetch_env!(@app, :ttl_check_interval)
  end

  @spec exchange_rate_cache :: atom()
  def exchange_rate_cache do
    Application.fetch_env!(@app, :exchange_rate_cache)
  end
end
