defmodule BEAMBetterHaveMyMoneyWeb.Middlewares.HandleErrors do
  @moduledoc false
  @behaviour Absinthe.Middleware

  @impl Absinthe.Middleware

  @spec call(Absinthe.Resolution.t(), any) :: Absinthe.Resolution.t()
  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
  end

  defp handle_error(%ErrorMessage{message: message, code: code, details: details}) do
    [%{message: message, code: code, details: details}]
  end

  defp handle_error(error), do: [error]
end
