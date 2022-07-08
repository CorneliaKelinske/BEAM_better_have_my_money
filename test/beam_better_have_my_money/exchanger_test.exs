defmodule BEAMBetterHaveMyMoney.ExchangerTest do
  use ExUnit.Case, async: true

  alias BEAMBetterHaveMyMoney.{Exchanger, ExchangeRateStorage}

  @currencies {"CAD", "USD"}

  setup do
    Exchanger.start_link(@currencies)
    :ok
  end

  describe "run/2" do
    test "retrieves an exchange rate and stores it in the Exchange Rate Storage" do
      assert "1.11" === ExchangeRateStorage.get_exchange_rate("CAD", "USD")
    end
  end
end
