defmodule BEAMBetterHaveMyMoney.Exchanger.ExchangeRate do
  @moduledoc """
  Representation of the exchange rate info obtained from the
  exchange rate API
  """
  alias BEAMBetterHaveMyMoney.Accounts.Wallet

  @type currency :: Wallet.currency()

  @enforce_keys [:from_currency, :to_currency, :rate]
  defstruct [:from_currency, :to_currency, :rate]

  @type t :: %__MODULE__{
          from_currency: currency(),
          to_currency: currency,
          rate: float()
        }

  @spec new(map, currency(), currency()) :: t()
  def new(%{"5. Exchange Rate" => rate}, from_currency, to_currency) do
    %__MODULE__{
      from_currency: from_currency,
      to_currency: to_currency,
      rate: String.to_float(rate)
    }
  end
end
