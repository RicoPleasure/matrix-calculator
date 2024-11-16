defmodule MatrixCalculatorElixirWeb.Calculator.Index do
  use MatrixCalculatorElixirWeb, :live_view

  # Operações singulares

  # Map

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:form1, to_form(%{a1: 0, a2: 0, a3: 0, b1: 0, b2: 0, b3: 0, c1: 0, c2: 0, c3: 0}))
                 |> assign(:form2, to_form(%{a1: 0, a2: 0, a3: 0, b1: 0, b2: 0, b3: 0, c1: 0, c2: 0, c3: 0}))
                 |> assign(:constant1, to_form(%{const: 0}))
                 |> assign(:constant2, to_form(%{const: 0}))
  }
  end

  # Determinante

  def handle_event("determinante", %{"source" => source}, socket) do
    matrix =
      case source do
        "matrix1" -> socket.assigns.matrix1
        "matrix2" -> socket.assigns.matrix2
      end

    result = Matrix.determinant([
      [matrix["a1"] |> String.to_float(),matrix["a2"] |> String.to_float(),matrix["a3"] |> String.to_float()],
      [matrix["b1"] |> String.to_float(),matrix["b2"] |> String.to_float(),matrix["b3"] |> String.to_float()],
      [matrix["c1"] |> String.to_float(),matrix["c2"] |> String.to_float(),matrix["c3"] |> String.to_float()]
    ])

    {:noreply, socket |> assign(:result ,result) |> assign(:result_type, :single)}
  end

  def verifica_int_float(string) do
    if  
  end

  # Transposta

  def handle_event("transposta",  %{"source" => source}, socket) do
    matrix =
      case source do
        "matrix1" -> socket.assigns.matrix1
        "matrix2" -> socket.assigns.matrix2
      end

    result = Matrix.transpose([
      [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
      [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
      [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
    ])

    {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
  end

  # Multiplicar por

  def handle_event("multiply-by",  %{"source" => source, "constant" => constant}, socket) do
    matrix =
      case source do
        "matrix1" -> socket.assigns.matrix1
        "matrix2" -> socket.assigns.matrix2
      end

    constant =
      case constant do
        "constant1" -> socket.assigns.constantvalue1
        "constant2" -> socket.assigns.constantvalue2
      end

    if not is_nil(constant["const"]) and constant["const"] != "" and String.match?(constant["const"], ~r/^\d+$/) do

      result = Matrix.multiply_by_constant(String.to_integer(constant["const"]), [
        [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
        [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
        [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
      ])

      {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
    else
      result = "Escreva um valor para multiplicar por"

      {:noreply, socket |> assign(:result, result) |> assign(:result_type, :error )}
    end

  end

  # Inversa

  def handle_event("inversa", %{"source" => source}, socket) do

    matrix =
      case source do
        "matrix1" -> socket.assigns.matrix1
        "matrix2" -> socket.assigns.matrix2
      end

    if Matrix.determinant([
      [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
      [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
      [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
    ]) != 0 do
      result = Matrix.inverse([
        [matrix["a1"] |> String.to_integer(),matrix["a2"] |> String.to_integer(),matrix["a3"] |> String.to_integer()],
        [matrix["b1"] |> String.to_integer(),matrix["b2"] |> String.to_integer(),matrix["b3"] |> String.to_integer()],
        [matrix["c1"] |> String.to_integer(),matrix["c2"] |> String.to_integer(),matrix["c3"] |> String.to_integer()]
      ])
      {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
    else
      result = "A função não admite inversa pois det(A) = 0"
      {:noreply, socket |> assign(:result, result) |> assign(:result_type, :error)}
    end
  end

  # Operações entre matrizes

  # Multiplicação

  def handle_event("multiplicacao_matrizes", _params, socket) do
    matrix1 = socket.assigns.matrix1
    matrix2 = socket.assigns.matrix2
    result = Matrix.multiply_by_other_matrix([
      [matrix1["a1"] |> String.to_integer(),matrix1["a2"] |> String.to_integer(),matrix1["a3"] |> String.to_integer()],
      [matrix1["b1"] |> String.to_integer(),matrix1["b2"] |> String.to_integer(),matrix1["b3"] |> String.to_integer()],
      [matrix1["c1"] |> String.to_integer(),matrix1["c2"] |> String.to_integer(),matrix1["c3"] |> String.to_integer()]
    ],[
      [matrix2["a1"] |> String.to_integer(),matrix2["a2"] |> String.to_integer(),matrix2["a3"] |> String.to_integer()],
      [matrix2["b1"] |> String.to_integer(),matrix2["b2"] |> String.to_integer(),matrix2["b3"] |> String.to_integer()],
      [matrix2["c1"] |> String.to_integer(),matrix2["c2"] |> String.to_integer(),matrix2["c3"] |> String.to_integer()]
    ]
    )

    {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
  end

  # Soma

  def handle_event("soma_matrizes", _params, socket) do
    matrix1 = socket.assigns.matrix1
    matrix2 = socket.assigns.matrix2
    result = Matrix.sum_matrices([
      [matrix1["a1"] |> String.to_integer(),matrix1["a2"] |> String.to_integer(),matrix1["a3"] |> String.to_integer()],
      [matrix1["b1"] |> String.to_integer(),matrix1["b2"] |> String.to_integer(),matrix1["b3"] |> String.to_integer()],
      [matrix1["c1"] |> String.to_integer(),matrix1["c2"] |> String.to_integer(),matrix1["c3"] |> String.to_integer()]
    ],[
      [matrix2["a1"] |> String.to_integer(),matrix2["a2"] |> String.to_integer(),matrix2["a3"] |> String.to_integer()],
      [matrix2["b1"] |> String.to_integer(),matrix2["b2"] |> String.to_integer(),matrix2["b3"] |> String.to_integer()],
      [matrix2["c1"] |> String.to_integer(),matrix2["c2"] |> String.to_integer(),matrix2["c3"] |> String.to_integer()]
    ]
    )

    {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
  end

  # Subtração

  def handle_event("subtracao_matrizes", _params, socket) do
    matrix1 = socket.assigns.matrix1
    matrix2 = socket.assigns.matrix2
    result = Matrix.subtract_matrices([
      [matrix1["a1"] |> String.to_integer(),matrix1["a2"] |> String.to_integer(),matrix1["a3"] |> String.to_integer()],
      [matrix1["b1"] |> String.to_integer(),matrix1["b2"] |> String.to_integer(),matrix1["b3"] |> String.to_integer()],
      [matrix1["c1"] |> String.to_integer(),matrix1["c2"] |> String.to_integer(),matrix1["c3"] |> String.to_integer()]
    ],[
      [matrix2["a1"] |> String.to_integer(),matrix2["a2"] |> String.to_integer(),matrix2["a3"] |> String.to_integer()],
      [matrix2["b1"] |> String.to_integer(),matrix2["b2"] |> String.to_integer(),matrix2["b3"] |> String.to_integer()],
      [matrix2["c1"] |> String.to_integer(),matrix2["c2"] |> String.to_integer(),matrix2["c3"] |> String.to_integer()]
    ]
    )

    {:noreply, socket |> assign(:result, result) |> assign(:result_type, :grid)}
  end

  # Clear button

  # Form Validation


  # Change inputs

  def handle_event("change-matrix1", params, socket) do
    {:noreply, socket |> assign(:matrix1, params)}
  end

  def handle_event("change-matrix2", params, socket) do
    {:noreply, socket |> assign(:matrix2, params)}
  end

  def handle_event("change-constant1", params, socket) do
    {:noreply, socket |> assign(:constantvalue1, params)}
  end

  def handle_event("change-constant2", params, socket) do
    {:noreply, socket |> assign(:constantvalue2, params)}
  end

end
