defmodule BEAMBetterHaveMyMoney.Config do
  @app :beam_better_have_my_money

  @spec currencies :: [String.t()]
  def currencies do
    Application.fetch_env!(@app, :currencies)
  end

  @spec exchange_rate_server :: String.t()
  def exchange_rate_server do
    Application.fetch_env!(@app, :exchange_rate_server)
  end
end
