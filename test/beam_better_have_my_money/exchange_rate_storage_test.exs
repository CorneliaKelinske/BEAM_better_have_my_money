defmodule BEAMBetterHaveMyMoney.ExchangeRateStorageTest do
  use ExUnit.Case, async: true

  alias BEAMBetterHaveMyMoney.Exchanger.ExchangeRate
  alias BEAMBetterHaveMyMoney.ExchangeRateStorage

  @test_rate %ExchangeRate{from_currency: :money1, to_currency: :money2, rate: "3"}

  describe "store_exchange_rate/1" do
    test "stores an exchange rate and removes it based on a given ttl and ttl interval check time" do
      assert :ok = ExchangeRateStorage.store_exchange_rate(@test_rate)
      assert {:ok, "3"} === ExchangeRateStorage.get_exchange_rate(:money1, :money2)
      Process.sleep(100)

      assert {:error,
              %ErrorMessage{
                code: :not_found,
                message: "Exchange rate currently not available. Please try again!",
                details: %{from_currency: :money1, to_currency: :money2}
              }} = ExchangeRateStorage.get_exchange_rate(:money1, :money2)
    end
  end
end
