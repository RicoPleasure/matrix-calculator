defmodule Matrix do

  # Validate if it is a matrix

  def isValid([[]]), do: true
  def isValid([[_]]), do: true

  def isValid([first_row | rest]) do
    Enum.all?(rest, fn row -> length(first_row) == length(row) end)
  end

  # Validate if it is a square matrix

  def isSquare([[]]), do: true
  def isSquare([[_]]), do: true

  def isSquare(matrix) do
    Enum.all?(matrix, fn row -> length(matrix) == length(row) end)
  end

  # Multiplicar matriz por uma constante #
  def multiplyByConstant(_constant, []), do: []

  def multiplyByConstant(constant,[linha | restoLinhas]) do
    [Enum.map(linha, fn n -> n * constant end) | multiplyByConstant(constant, restoLinhas)]
  end

  # Transformar matriz na transposta #
  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose([[x | xs] | restoLinhas]) do
    [ [x | Enum.map(restoLinhas, &hd/1)] | transpose([xs | Enum.map(restoLinhas, &tl/1)])]
  end

  defp dotProduct(row, col) do
    row
    |> Enum.zip(col)
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  # Determinantes

  # Call/Validation Function

  def determinant(matrix) do
    if isSquare(matrix) do
      do_determinant(matrix)
    else
      {:error, "The matrix must be square to be able to calculate the determinant"}
    end
  end

  # Core function
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

      multiplyByConstant(1 / determinant_value, c_transpose)
    end
  end

  # Operações entre matrizes

  # Multiplicar matriz por outra matriz #
  def multiplyByOtherMatrix([],_), do: []
  def multiplyByOtherMatrix(_,[]), do: []

  def multiplyByOtherMatrix(matrix1, matrix2) do
    matrix2_transposed = transpose(matrix2)
    result = for row <- matrix1 do
      for col <- matrix2_transposed, into: [] do
        dotProduct(row,col)
      end
    end
    result
  end

  # Somar matriz por outra matriz #
  def sumMatrices([],_), do: []
  def sumMatrices(_,[]), do: []

  def sumMatrices(matrix1, matrix2) do
    result = for row <- matrix1 do
      for col <- matrix2, into: [] do
        hd(row) + hd(col)
      end
    end
    result
  end

  # Subtrair matriz por outra matriz
  def subtractMatrices([],_), do: []
  def subtractMatrices(_,[]), do: []

  def subtractMatrices(matrix1, matrix2) do
    result = for row <- matrix1 do
      for col <- matrix2, into: [] do
        hd(row) - hd(col)
      end
    end
    result
  end


end
