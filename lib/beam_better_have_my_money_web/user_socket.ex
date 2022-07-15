defmodule BEAMBetterHaveMyMoneyWeb.UserSocket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket,
    schema: BEAMBetterHaveMyMoneyWeb.Schema

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
