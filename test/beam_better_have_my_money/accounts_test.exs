defmodule BEAMBetterHaveMyMoney.AccountsTest do
  use BEAMBetterHaveMyMoney.DataCase

  alias BEAMBetterHaveMyMoney.{Accounts, Accounts.User}

  import BEAMBetterHaveMyMoney.AccountsFixtures, only: [user: 1, wallet: 1]
  @valid_user_params %{name: "Harry", email: "dresden@example.com"}
  @invalid_params %{email: nil, name: nil}

  describe "all_users/1" do
    setup :user

    test "returns a list of all users when no params are given", %{user: %{id: id, name: name, email: email}} do
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

      assert {:ok, %User{id: id, email: "dresden@example.com", name: "Harry"}} =
               Accounts.create_user(@valid_user_params)

      assert [%User{}] = Repo.all(User)
    end

    test "cannot create two users with identical email addresses" do

      assert {:ok, %User{id: id, email: "dresden@example.com", name: "Harry"}} =
        Accounts.create_user(@valid_user_params)

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_user_params)
      assert %{email: ["has already been taken"]} === errors_on(changeset)
    end

    test "returns error when invalid user params are given" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@invalid_params)
      assert %{email: ["can't be blank"], name: ["can't be blank"]} === errors_on(changeset)
    end
  end


end
