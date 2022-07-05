defmodule BEAMBetterHaveMyMoney.Exchanger.ExchangeRate do
  @moduledoc """
  Representation of the exchange rate info obtained from the
  exchange rate API
  """

  @enforce_keys [:from_currency, :to_currency, :exchange_rate]
  defstruct [:from_currency, :to_currency, :exchange_rate]

  @type t :: %__MODULE__{from_currency: String.t(), to_currency: String.t(), exchange_rate: float()}

  @spec new(map) :: t()
  def new(%{"1. From_Currency Code" => from_currency, "3. To_Currency_Code" => to_currency, "5. Exchange Rate" => exchange_rate}) do
    %__MODULE__{from_currency: from_currency, to_currency: to_currency, exchange_rate: exchange_rate}
  end
end
