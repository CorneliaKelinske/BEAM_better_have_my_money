if Mix.env() !== :test do
  alias BEAMBetterHaveMyMoney.Accounts

  users = [
    {%{
       id: 1,
       name: "Bill",
       email: "bill@gmail.com"
     }, [:CAD, :USD]},
    {%{
       id: 2,
       name: "Alice",
       email: "alice@gmail.com"
     }, [:CAD, :USD, :EUR]},
    {%{
       id: 3,
       name: "Jill",
       email: "jill@hotmail.com"
     }, [:CAD, :EUR]}
  ]

  for {user, currencies} <- users do
    Accounts.create_user(user)

    for currency <- currencies do
      Accounts.create_wallet(%{user_id: user.id, currency: currency, cent_amount: 100_000})
    end
  end
end
