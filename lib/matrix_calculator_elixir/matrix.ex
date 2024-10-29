defmodule Matrix do

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

  defp dotProduct(row, col) do
    row
    |> Enum.zip(col)
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  # Inversa de uma matriz



end
