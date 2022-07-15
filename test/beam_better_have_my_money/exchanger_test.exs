defmodule BEAMBetterHaveMyMoney.ExchangerTest do
  use ExUnit.Case, async: true

  alias BEAMBetterHaveMyMoney.{Exchanger, ExchangeRateStorage}

  @currencies {:money1, :money2}

  setup do
    start_supervised!({ConCache, name: :test_cache, ttl_check_interval: 20, global_ttl: 3_000})
    Exchanger.start_link(@currencies, :test_cache)
    :ok
  end

  describe "run/2" do
    test "retrieves an exchange rate and stores it in the Exchange Rate Storage" do
      Process.sleep(50)
      assert 1.11 === ExchangeRateStorage.get_exchange_rate(:money1, :money2, :test_cache)
    end
  end
end
