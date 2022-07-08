defmodule BEAMBetterHaveMyMoney.ExchangeRateStorageTest do
  use ExUnit.Case, async: true

  alias BEAMBetterHaveMyMoney.ExchangeRateStorage
  alias BEAMBetterHaveMyMoney.Exchanger.ExchangeRate

  @test_rate %ExchangeRate{from_currency: "Marbles", to_currency: "Painted Stones", rate: "3"}

  describe "store_exchange_rate/1" do

    test "stores an exchange rate and removes it based on a given ttl and ttl interval check time" do
      assert :ok = ExchangeRateStorage.store_exchange_rate(@test_rate)
      assert "3" === ExchangeRateStorage.get_exchange_rate("Marbles", "Painted Stones")
      Process.sleep(60)
      assert nil === ExchangeRateStorage.get_exchange_rate("Marbles", "Painted Stones")
    end
  end


end
