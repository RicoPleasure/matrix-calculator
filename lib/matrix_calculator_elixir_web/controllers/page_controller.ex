defmodule MatrixCalculatorElixirWeb.PageController do
  use MatrixCalculatorElixirWeb, :controller

  def home(conn, _params) do

    render(conn, :home)
  end
end
