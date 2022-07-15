defmodule BEAMBetterHaveMyMoney.ExchangerTest do
  use ExUnit.Case, async: true

  alias BEAMBetterHaveMyMoney.{Exchanger, ExchangeRateStorage}

  @currencies {"Money1", "Money2"}

  setup do
    Exchanger.start_link(@currencies, :test_cache)
    :ok
  end

  describe "run/2" do
    test "retrieves an exchange rate and stores it in the Exchange Rate Storage" do
      Process.sleep(100)
      assert 1.11 === ExchangeRateStorage.get_exchange_rate("Money1", "Money2")
    end
  end
end
