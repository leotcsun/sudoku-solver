require_relative "sudoku"


class SudokuBt < Sudoku
  # Sudoku Solver with basic Back Tracking Algorithm

  def assign_value(x, y, v)
    @node_searched += 1

    if @initial_board[x][y] != 0
      @node_searched -= 1
      false

    elsif check_row_with_value(x, v) \
          && check_column_with_value(y, v) \
          && check_square_with_value(x, y, v)

      @board[x][y] = v
      true

    else
      false
    end
  end



  def search(x, y)

    if (y > 8)
      x += 1
      return true if x == 9
      y = 0
    end

    if @initial_board[x][y] != 0 then return search(x, y + 1) end

    (1..9).each do |v|
      if assign_value(x, y, v)
        return true if search(x, y + 1)
      end
      clear_value(x, y)
    end

    false
  end

end


