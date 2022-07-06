defmodule BeamBetterHaveMyMoney.Config do
  @app :beam_better_have_my_money

def currencies do
Application.fetch_env!(@app, :currencies)
end
end
