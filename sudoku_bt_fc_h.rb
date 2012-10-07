require_relative "sudoku_bt_fc"

class SudokuBtFcH < SudokuBtFc
  # Sudoku Solver with Back Tracking, Forward Checking, and the 3 Heuristics

  def search(x, y)
    if (y > 8)
      x += 1
      return true if x == 9
      y = 0
    end

    if @initial_board[x][y] != 0
      next_x, next_y = select_unassigned_var
      return search(next_x, next_y)
    end


    values_to_try = get_least_constraining_value(x, y)

    values_to_try.each do |v|
      if assign_value(x, y, v)

        next_x, next_y = select_unassigned_var
        return true if next_x.nil? && next_y.nil?

        if has_no_empty_domain(x, y)
          return true if search(next_x, next_y)
        end
      end

      clear_value(x, y)
    end

    false
  end

  # Minimum-remaining-values
  def select_unassigned_var
    minimum_remaining_values = 10
    max_degree = 0
    x = y = nil

    (0..8).each do |i|
      (0..8).each do |j|

        if !@domains[i][j].nil? && @board[i][j] == 0

          if @domains[i][j].length < minimum_remaining_values
            minimum_remaining_values = @domains[i][j].length
            x, y = i, j

          elsif @domains[i][j].length == minimum_remaining_values
            degree = get_degree(i, j)
            if degree > max_degree
              max_degree = degree
              x, y = i, j
            end
          end

        end
      end
    end

    return x, y
  end


  # Degree heuristics
  def get_degree(x, y)
    degree = 0
    x_start, y_start, x_boundary, y_boundary = find_square_boundaries(x, y)

    (x_start..x_boundary).each do |i|
      (y_start..y_boundary).each do |j|
        degree += 1 if @board[i][j] == 0
      end
    end

    (0..8).each do |z|
      if @board[z][y] == 0 && !(x_start..x_boundary).include?(z)
        degree += 1
      end

      if @board[x][z] == 0 && !(y_start..y_boundary).include?(z)
        degree +=1
      end
    end

    degree
  end


  # Least-constraining-value
  def get_least_constraining_value(x, y)

    result = {}
    @domains[x][y].each do |i|
      result[i] = 0
    end

    x_start, y_start, x_boundary, y_boundary = find_square_boundaries(x, y)

    (x_start..x_boundary).each do |i|
      (y_start..y_boundary).each do |j|
        unless @domains[i][j].nil?
          @domains[i][j].each do |d|
            result[d] += 1 if @domains[x][y].include?(d)
          end
        end
      end
    end

    (0..8).each do |z|
      unless @domains[z][y].nil? || (x_start..x_boundary).include?(z)
        @domains[z][y].each do |d|
          result[d] += 1 if @domains[x][y].include?(d)
        end
      end

      unless @domains[x][z].nil? || (y_start..y_boundary).include?(z)
        @domains[x][z].each do |d|
          result[d] += 1 if @domains[x][y].include?(d)
        end
      end
    end

    Hash[result.sort]
    result.keys
  end

end
