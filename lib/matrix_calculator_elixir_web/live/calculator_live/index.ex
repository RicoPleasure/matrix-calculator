defmodule MatrixCalculatorElixirWeb.Calculator.Index do
  use MatrixCalculatorElixirWeb, :live_view

  # Map

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:form, to_form(%{a1: 0, a2: 0, a3: 0, b1: 0, b2: 0, b3: 0, c1: 0, c2: 0, c3: 0}))
                 |> assign(:constant, to_form(%{const: 0}))
  }
  end

  # Determinante

  def handle_event("determinante",_params, socket) do
    matrix = socket.assigns.matrix
    result = Matrix.determinant([
      [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
      [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
      [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
    ])

    {:noreply, socket |> assign(:result ,result) |> assign(:result_type, :single)}
  end

  # Transposta

  def handle_event("transposta", _params, socket) do
    matrix = socket.assigns.matrix
    result = Matrix.transpose([
      [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
      [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
      [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
    ])

    result |> to_string()
    {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
  end

  # Multiplicar por

  def handle_event("multiply-by", _params, socket) do
    matrix = socket.assigns.matrix
    constant = socket.assigns.constantvalue
    result = Matrix.multiplyByConstant(String.to_integer(constant["const"]), [
      [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
      [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
      [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
    ])

    IO.inspect(matrix)
    IO.inspect(result)
    {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
  end

  # Change inputs

  def handle_event("change-matrix",params,socket) do
    {:noreply, socket |> assign(:matrix, params)}
  end

  def handle_event("change-constant",params,socket) do
    {:noreply, socket |> assign(:constantvalue, params)}
  end

end
