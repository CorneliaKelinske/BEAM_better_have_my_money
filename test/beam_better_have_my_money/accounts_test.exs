defmodule BEAMBetterHaveMyMoney.AccountsTest do
  use BEAMBetterHaveMyMoney.DataCase

  alias BEAMBetterHaveMyMoney.Accounts

  describe "users" do
    alias BEAMBetterHaveMyMoney.Accounts.User

    import BEAMBetterHaveMyMoney.AccountsFixtures

    @invalid_attrs %{email: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", name: "some updated name"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "wallets" do
    alias BEAMBetterHaveMyMoney.Accounts.Wallet

    import BEAMBetterHaveMyMoney.AccountsFixtures

    @invalid_attrs %{cent_amount: nil, currency: nil}

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Accounts.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Accounts.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      valid_attrs = %{cent_amount: 42, currency: "some currency"}

      assert {:ok, %Wallet{} = wallet} = Accounts.create_wallet(valid_attrs)
      assert wallet.cent_amount == 42
      assert wallet.currency == "some currency"
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      update_attrs = %{cent_amount: 43, currency: "some updated currency"}

      assert {:ok, %Wallet{} = wallet} = Accounts.update_wallet(wallet, update_attrs)
      assert wallet.cent_amount == 43
      assert wallet.currency == "some updated currency"
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_wallet(wallet, @invalid_attrs)
      assert wallet == Accounts.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Accounts.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Accounts.change_wallet(wallet)
    end
  end
end
