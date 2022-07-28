defmodule BEAMBetterHaveMyMoneyWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests.
  """
  use ExUnit.CaseTemplate
  alias Absinthe.Phoenix.SubscriptionTest
  alias Phoenix.ChannelTest

  using do
    quote do
      use BEAMBetterHaveMyMoneyWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: BEAMBetterHaveMyMoneyWeb.Schema

      setup do
        {:ok, socket} = ChannelTest.connect(BEAMBetterHaveMyMoneyWeb.UserSocket, %{})
        {:ok, socket} = SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
