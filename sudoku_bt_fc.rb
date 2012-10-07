require_relative "sudoku_bt"

class SudokuBtFc < SudokuBt
  # Sudoku Solver with Basic Tracking and Forward Checking
  # A 3-D array is used to keep track of domain values for each entry

  def setup(board)
    super

    # create an domain array for each entry on the board
    @domains = Array.new(9) { Array.new(9) }
    @domains_update_count = 0

    (0..8).each do |x|
      (0..8).each do |y|
        # domains for a initially filled spot is nil
        @domains[x][y] = (@board[x][y] == 0) ? @@one_to_nine.dup : nil
      end
    end

    (0..8).each do |x|
      (0..8).each do |y|
        update_domains_at(x, y)
      end
    end
  end


  def assign_value(x, y, v)
    @node_searched += 1

    if @initial_board[x][y] != 0
      @node_searched -= 1
      false

    elsif check_row_with_value(x, v) \
          && check_column_with_value(y, v) \
          && check_square_with_value(x, y, v)

      @board[x][y] = v
      update_domains(x, y)

    else
      false
    end
  end


  def update_domains(x, y)
    x_start, y_start, x_boundary, y_boundary = find_square_boundaries(x, y)

    s = usable_domains_in_square(x, y)
    r = usable_domains_in_row(x)
    c = usable_domains_in_column(y)

    (x_start..x_boundary).each do |i|
      (y_start..y_boundary).each do |j|
        update_domains_at(i, j, s, nil, nil)
      end
    end

    (0..8).each do |z|
      update_domains_at(z, y, nil, nil, c)
      update_domains_at(x, z, nil, r, nil)
    end
  end


  def update_domains_at(x, y, s = nil, r = nil, c = nil)
    unless @domains[x][y].nil?
      s ||= usable_domains_in_square(x, y)
      r ||= usable_domains_in_row(x)
      c ||= usable_domains_in_column(y)

      @domains[x][y] = s & r & c
      @domains_update_count += 1
    end
  end


  def usable_domains_in_square(x, y)
    x_start, y_start, x_boundary, y_boundary = find_square_boundaries(x, y)

    a = []
    (x_start..x_boundary).each do |i|
      (y_start..y_boundary).each do |j|
        a << @board[i][j] if @board[i][j] != 0
      end
    end

    @@one_to_nine - a
  end


  def usable_domains_in_row(x)
    a = []
    (0..8).each do |y|
      a << @board[x][y] if @board[x][y] != 0
    end

    @@one_to_nine - a
  end


  def usable_domains_in_column(y)
    a = []
    (0..8).each do |x|
      a << @board[x][y] if @board[x][y] != 0
    end

    @@one_to_nine - a
  end


  def has_no_empty_domain(x, y)
    x_start, y_start, x_boundary, y_boundary = find_square_boundaries(x, y)

    (x_start..x_boundary).each do |i|
      (y_start..y_boundary).each do |j|
        if !@domains[i][j].nil? && @board[i][j] == 0
          return false if @domains[i][j].empty?
        end
      end
    end

    (0..8).each do |z|

      if !@domains[z][y].nil? \
         && @board[z][y] == 0 \
         && @domains[z][y].empty?
        return false
      end

      if !@domains[x][z].nil? \
         && @board[x][z] == 0 \
         && @domains[x][z].empty?
        return false
      end
    end

    true
  end


  def clear_value(x, y)
    super
    update_domains(x, y)
  end


  def search(x, y)

    if (y > 8)
      x += 1
      return true if x == 9
      y = 0
    end

    if @initial_board[x][y] != 0
      return search(x, y + 1)
    end

    @domains[x][y].each do |v|
      if assign_value(x, y, v)
        if has_no_empty_domain(x, y)
          return true if search(x, y + 1)
        end
      end
      clear_value(x, y)
    end

    false
  end


  def print_domains
    (0..8).each do |x|
      (0..8).each do |y|
        puts "Domains at #{x} #{y} #{@domains[x][y]}"
      end
    end
  end

end
