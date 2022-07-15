defmodule BEAMBetterHaveMyMoney.AccountsTest do
  use BEAMBetterHaveMyMoney.DataCase

  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.User, Accounts.Wallet}

  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, wallet: 1]
  @valid_user_params %{name: "Harry", email: "dresden@example.com"}
  @valid_wallet_params %{currency: :CAD, cent_amount: 1_000}
  @invalid_user_params %{email: nil, name: nil}
  @invalid_wallet_params %{user_id: nil, currency: nil, cent_amount: nil}

  describe "all_users/1" do
    setup :user

    test "returns a list of all users when no params are given", %{
      user: %{id: id, name: name, email: email}
    } do
      assert [%User{id: ^id, name: ^name, email: ^email}] = Accounts.all_users(%{})
    end

    test "returns a list of all users matching the given parameter(s)", %{
      user: %{id: id, name: name, email: email}
    } do
      assert [%User{id: ^id, name: ^name, email: ^email}] = Accounts.all_users(%{name: name})
    end

    test "returns an empty list when no users with matching params are found" do
      assert [] = Accounts.all_users(%{name: "does not exist"})
    end
  end

  describe "find_user/1" do
    setup :user

    test "returns a a tuple with :ok and the corresponding user when a matching user exists", %{
      user: %{id: id, name: name, email: email}
    } do
      assert {:ok, %User{id: ^id, name: ^name, email: ^email}} = Accounts.find_user(%{id: id})
    end

    test "returns a a tuple with :ok and the corresponding user when several parameters are given",
         %{
           user: %{id: id, name: name, email: email}
         } do
      assert {:ok, %User{id: ^id, name: ^name, email: ^email}} =
               Accounts.find_user(%{id: id, name: name})
    end

    test "returns a tuple with :error and reason when no search params are given" do
      assert {:error,
              %ErrorMessage{
                code: :not_found,
                message: "no records found",
                details: %{params: %{}, query: BEAMBetterHaveMyMoney.Accounts.User}
              }} ===
               Accounts.find_user(%{})
    end

    test "returns tuple with :error and info when a matching user does not exist", %{
      user: %{id: id}
    } do
      assert Accounts.find_user(%{id: id + 1}) ===
               {:error,
                %ErrorMessage{
                  code: :not_found,
                  details: %{params: %{id: id + 1}, query: BEAMBetterHaveMyMoney.Accounts.User},
                  message: "no records found"
                }}
    end
  end

  describe "create_user/1" do
    test "creates a new user when valid params are given" do
      assert {:ok, %User{email: "dresden@example.com", name: "Harry"}} =
               Accounts.create_user(@valid_user_params)

      assert [%User{}] = Repo.all(User)
    end

    test "cannot create two users with identical email addresses" do
      assert {:ok, %User{email: "dresden@example.com", name: "Harry"}} =
               Accounts.create_user(@valid_user_params)

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_user_params)
      assert %{email: ["has already been taken"]} === errors_on(changeset)
    end

    test "returns error when invalid user params are given" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@invalid_user_params)
      assert %{email: ["can't be blank"], name: ["can't be blank"]} === errors_on(changeset)
    end
  end

  describe "update_user/2" do
    setup :user

    test "updates an existing user", %{user: user} do
      assert [%User{email: "email@example.com"}] = Accounts.all_users(%{})

      assert {:ok, %User{email: "wizard@example.com"}} =
               Accounts.update_user(user.id, %{email: "wizard@example.com"})

      assert [%User{email: "wizard@example.com"}] = Accounts.all_users(%{})
    end

    test "returns the unchanged user when no update params are provided",
         %{user: user} do
      assert {:ok, %User{email: "email@example.com"}} = Accounts.update_user(user.id, %{})
      assert [%User{email: "email@example.com"}] = Accounts.all_users(%{})
    end

    test "returns tuple with :error and map with error info when another user's email is provided",
         %{user: user} do
      assert [%User{email: "email@example.com"}] = Accounts.all_users(%{})

      assert {:ok, %User{email: user2_email}} =
               Accounts.create_user(%{name: "user2", email: "user2@example.com"})

      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.update_user(user.id, %{email: user2_email})

      assert %{email: ["has already been taken"]} === errors_on(changeset)
    end
  end

  describe "delete_user/1" do
    setup [:user, :wallet]

    test "deletes a user including their wallets", %{user: user} do
      id = user.id
      assert [%Wallet{user_id: ^id}] = Accounts.all_wallets()
      Accounts.delete_user(user)

      assert Accounts.find_user(%{id: user.id}) ===
               {:error,
                %ErrorMessage{
                  code: :not_found,
                  details: %{params: %{id: id}, query: BEAMBetterHaveMyMoney.Accounts.User},
                  message: "no records found"
                }}

      assert Accounts.all_users() === []
      assert Accounts.all_wallets() === []
    end
  end

  describe "all_wallets/1" do
    setup [:user, :wallet]

    test "returns a list of all wallets when no params are given", %{
      user: %{id: id},
      wallet: %{currency: currency, cent_amount: cent_amount}
    } do
      assert [%Wallet{user_id: ^id, currency: ^currency, cent_amount: ^cent_amount}] =
               Accounts.all_wallets()
    end

    test "returns a list of all wallets matching the given parameter(s)", %{
      user: %{id: id}
    } do
      assert [%Wallet{user_id: ^id, currency: :CAD, cent_amount: 1_000}] =
               Accounts.all_wallets(%{currency: :CAD})
    end
  end

  describe "find_wallet/1" do
    setup [:user, :wallet]

    test "returns a a tuple with :ok and the corresponding wallet when a wallet for a given user ID and currency exists",
         %{
           user: %{id: id},
           wallet: %{currency: currency}
         } do
      assert {:ok, %Wallet{user_id: ^id}} =
               Accounts.find_wallet(%{user_id: id, currency: currency})
    end

    test "returns tuple with :error and reason when there is no wallet for a given user ID and currency combination",
         %{user: %{id: id}, wallet: %{currency: currency}} do
      assert Accounts.find_wallet(%{id: id + 1, currency: currency}) ===
               {:error,
                %ErrorMessage{
                  code: :not_found,
                  details: %{
                    params: %{id: id + 1, currency: :CAD},
                    query: BEAMBetterHaveMyMoney.Accounts.Wallet
                  },
                  message: "no records found"
                }}
    end
  end

  describe "create_wallet/1" do
    setup :user

    test "creates a new wallet when valid params are given", %{user: %{id: id}} do
      create_params = Map.put(@valid_wallet_params, :user_id, id)

      assert {:ok, %Wallet{user_id: ^id, currency: :CAD, cent_amount: 1_000}} =
               Accounts.create_wallet(create_params)

      assert [%Wallet{user_id: ^id}] = Repo.all(Wallet)
    end

    test "cannot create two wallets with identical currency for the same user", %{user: %{id: id}} do
      create_params = Map.put(@valid_wallet_params, :user_id, id)

      assert {:ok, %Wallet{user_id: ^id, currency: :CAD, cent_amount: 1_000}} =
               Accounts.create_wallet(create_params)

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_wallet(create_params)
      assert %{currency: ["has already been taken"]} === errors_on(changeset)
    end

    test "can create two wallets with different currencies for the same user", %{user: %{id: id}} do
      create_params = Map.put(@valid_wallet_params, :user_id, id)

      assert {:ok, %Wallet{user_id: ^id, currency: :CAD, cent_amount: 1_000}} =
               Accounts.create_wallet(create_params)

      new_currency_params = Map.put(create_params, :currency, :USD)

      assert {:ok, %Wallet{user_id: ^id, currency: :USD, cent_amount: 1_000}} =
               Accounts.create_wallet(new_currency_params)

      assert [%Wallet{user_id: ^id}, %Wallet{user_id: ^id}] = Repo.all(Wallet)
    end

    test "returns error when invalid wallet params are given" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.create_wallet(@invalid_wallet_params)

      assert %{
               user_id: ["can't be blank"],
               currency: ["can't be blank"],
               cent_amount: ["can't be blank"]
             } === errors_on(changeset)
    end
  end

  describe "update_wallet/2" do
    setup [:user, :wallet]

    test "returns updated wallet", %{user: %{id: id}, wallet: %{currency: currency}} do
      assert {:ok,
              %Wallet{
                user_id: ^id,
                currency: ^currency,
                cent_amount: 5_000
              }} =
               Accounts.update_wallet(%Wallet{user_id: id, currency: currency}, %{
                 cent_amount: 5_000
               })

      assert [%Wallet{cent_amount: 5_000}] = Accounts.all_wallets()
    end

    test "returns unchanged wallet when no update params are provided",
         %{user: %{id: id}, wallet: %Wallet{currency: currency, cent_amount: cent_amount}} do
      assert {:ok,
              %Wallet{
                user_id: ^id,
                currency: ^currency,
                cent_amount: ^cent_amount
              }} = Accounts.update_wallet(%Wallet{user_id: id, currency: currency}, %{})

      assert [%Wallet{cent_amount: 1_000}] = Accounts.all_wallets()
    end
  end

  describe "delete_wallet/1" do
    setup [:user, :wallet]

    test "deletes a wallet", %{user: %{id: id}, wallet: %{currency: currency} = wallet} do
      Accounts.delete_wallet(wallet)

      assert Accounts.find_wallet(%{user_id: id, currency: currency}) ===
               {:error,
                %ErrorMessage{
                  code: :not_found,
                  details: %{
                    params: %{user_id: id, currency: currency},
                    query: BEAMBetterHaveMyMoney.Accounts.Wallet
                  },
                  message: "no records found"
                }}

      assert Accounts.all_wallets() === []
    end
  end
end
