defmodule BEAMBetterHaveMyMoney.Repo do
  use Ecto.Repo,
    otp_app: :beam_better_have_my_money,
    adapter: Ecto.Adapters.Postgres
end
