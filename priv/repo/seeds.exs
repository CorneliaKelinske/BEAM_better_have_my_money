if Mix.env() !== :test do
  alias BEAMBetterHaveMyMoney.Accounts

  users = [
    %{
      id: 1,
      name: "Bill",
      email: "bill@gmail.com"
    },
    %{
      id: 2,
      name: "Alice",
      email: "alice@gmail.com"
    },
    %{
      id: 3,
      name: "Jill",
      email: "jill@hotmail.com"
    }
  ]

  for user <- users do
    Accounts.create_user(user)
  end

  for user <- users,
      user.name === "Bill" do
    Accounts.create_wallet(%{user_id: user.id, currency: :CAD, cent_amount: 100_000})
    Accounts.create_wallet(%{user_id: user.id, currency: :USD, cent_amount: 100_000})
  end

  for user <- users,
      user.name === "Alice" do
    Accounts.create_wallet(%{user_id: user.id, currency: :CAD, cent_amount: 100_000})
    Accounts.create_wallet(%{user_id: user.id, currency: :USD, cent_amount: 100_000})
    Accounts.create_wallet(%{user_id: user.id, currency: :EUR, cent_amount: 100_000})
  end

  for user <- users,
      user.name === "Jill" do
    Accounts.create_wallet(%{user_id: user.id, currency: :CAD, cent_amount: 100_000})
    Accounts.create_wallet(%{user_id: user.id, currency: :EUR, cent_amount: 100_000})
  end
end
