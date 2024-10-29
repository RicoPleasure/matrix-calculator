defmodule MatrixCalculatorElixir.Repo do
  use Ecto.Repo,
    otp_app: :matrix_calculator_elixir,
    adapter: Ecto.Adapters.Postgres
end
