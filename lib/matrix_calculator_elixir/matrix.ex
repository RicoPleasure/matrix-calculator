defmodule Matrix do

  # Valida se é uma matriz

  def is_valid([[]]), do: true
  def is_valid([[_]]), do: true

  def is_valid([first_row | rest]) do
    Enum.all?(rest, fn row -> length(first_row) == length(row) end)
  end

  # Valida se é uma matriz quadrada

  def is_square([[]]), do: true
  def is_square([[_]]), do: true

  def is_square(matrix) do
    Enum.all?(matrix, fn row -> length(matrix) == length(row) end)
  end

  # Multiplicar matriz por uma constante #
  def multiply_by_constant(_constant, []), do: []

  def multiply_by_constant(constant,[linha | restoLinhas]) do
    [Enum.map(linha, fn n -> n * constant end) | multiply_by_constant(constant, restoLinhas)]
  end

  # Transformar matriz na transposta #
  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose([[x | xs] | restoLinhas]) do
    [ [x | Enum.map(restoLinhas, &hd/1)] | transpose([xs | Enum.map(restoLinhas, &tl/1)])]
  end

  defp dot_product(row, col) do
    row
    |> Enum.zip(col)
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  # Determinantes

  # Função de chamada/validação

  def determinant(matrix) do
    if is_square(matrix) do
      do_determinant(matrix)
    else
      {:error, "The matrix must be square to be able to calculate the determinant"}
    end
  end

  # Função core
  defp do_determinant([[]]), do: 1
  defp do_determinant([[a]]), do: a

  defp do_determinant(matrix = [[x | xs] | _]) do
    Enum.with_index([x | xs]) |> Enum.reduce(0, fn {a, j}, acc ->
      sign = if rem(j, 2) == 0, do: 1, else: -1
      submatrix = minor_matrix(matrix, 0, j)
      acc + sign * a * do_determinant(submatrix)
    end)
  end

  defp minor_matrix(matrix, row_index, col_index) do
    matrix
    |> Enum.with_index()
    |> Enum.reject(fn {_row, i} -> i == row_index end)
    |> Enum.map(fn {row, _} ->
      row
      |> Enum.with_index()
      |> Enum.reject(fn {_elem, j} -> j == col_index end)
      |> Enum.map(fn {elem, _} -> elem end)
    end)
  end


  # Inversa de uma matriz

  def inverse(matrix) do
    determinant_value = determinant(matrix)

    if determinant_value == 0 do
      {:error, "Matrix not invertible"}
    else
      c = Enum.with_index(matrix) |> Enum.map(fn {row, i} ->
        Enum.with_index(row) |> Enum.map(fn {_elem, j} ->
          sign = if rem(i + j, 2) == 0, do: 1, else: -1
          submatrix = minor_matrix(matrix, i, j)
          IO.puts(determinant(submatrix))
          sign * determinant(submatrix)
        end)
      end)

      c_transpose = c |> transpose()

      multiply_by_constant(1 / determinant_value, c_transpose)
    end
  end

  # Operações entre matrizes

  # Multiplicar matriz por outra matriz #
  def multiply_by_other_matrix([],_), do: []
  def multiply_by_other_matrix(_,[]), do: []

  def multiply_by_other_matrix(matrix1, matrix2) do
    matrix2_transposed = transpose(matrix2)
    result = for row <- matrix1 do
      for col <- matrix2_transposed, into: [] do
        dot_product(row, col)
      end
    end
    result
  end

  # Somar matriz por outra matriz #
  def sum_matrices([],_), do: []
  def sum_matrices(_,[]), do: []

  def sum_matrices(matrix1, matrix2) do
      result = for {row1, row2} <- Enum.zip(matrix1, matrix2) do
        dot_sum(row1, row2)
      end
    result
  end

  defp dot_sum(row1, row2) do
    for {x, y} <- Enum.zip(row1, row2), do: x + y
  end

  # Subtrair matriz por outra matriz
  def subtract_matrices([],_), do: []
  def subtract_matrices(_,[]), do: []

  def subtract_matrices(matrix1, matrix2) do
      result = for {row1,row2} <- Enum.zip(matrix1, matrix2) do
        dot_subtract(row1,row2)
      end
    result
  end

  defp dot_subtract(row1, row2) do
    for {x, y} <- Enum.zip(row1, row2), do: x - y
  end

end
