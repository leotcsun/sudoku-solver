require "benchmark"


class Sudoku

  attr_reader :node_searched
  @@zero_board = Array.new(9) { Array.new(9, 0) }
  @@one_to_nine = [1, 2, 3, 4, 5, 6, 7, 8, 9]


  def initialize
  end


  def setup(board)
    @board = board.dup
    @initial_board = Marshal.load(Marshal.dump(board))
    @node_searched = 0
  end


  def to_s
    print_current_board
  end


  def reset_board
    @board = @initial_board.dup
    @node_searched = 0
  end


  def clear_board
    @board = @@zero_board.dup
    @node_searched = 0
  end


  def solved?
    check_squares && check_rows && check_columns
  end



  def find_square_boundaries(x, y)
    x_start = (x / 3.0).floor * 3
    y_start = (y / 3.0).floor * 3

    x_boundary = find_square_boundary(x)
    y_boundary = find_square_boundary(y)

    return x_start, y_start, x_boundary, y_boundary
  end


  def find_square_boundary(value)
    case value
    when 0..2 then 2
    when 3..5 then 5
    else 8
    end
  end


  def check_squares
    [0, 3, 6].each do |i|
      [0, 3, 6].each do |j|
        a = []

        (i..(i + 2)).each do |k|
          (j..(j + 2)).each do |l|
            a << @board[k][l] if @board[k][l] != 0
          end
        end

        return false unless all_filled?(a) && no_duplicate?(a)
      end
    end
    true
  end





  def check_rows
    (0..8).each do |i|
      a = []
      (0..8).each do |j|
        a << @board[i][j] if @board[i][j] != 0
      end

      return false unless all_filled?(a) && no_duplicate?(a)
    end
    true
  end


  def check_columns
    (0..8).each do |j|
      a = []
      (0..8).each do |i|
        a << @board[i][j] if @board[i][j] != 0
      end

      return false unless all_filled?(a) && no_duplicate?(a)
    end
    true
  end


  def check_square_with_value(x, y, v)
    x_start, y_start, x_boundary, y_boundary = find_square_boundaries(x, y)

    # check the square to see if values duplicate
    a = []
    a << v
    (x_start..x_boundary).each do |i|
      (y_start..y_boundary).each do |j|
        a << @board[i][j] if @board[i][j] != 0
      end
    end

    no_duplicate?(a)
  end



  def check_row_with_value(x, v)
    a = []
    a << v
    (0..8).each do |y|
      a << @board[x][y] if @board[x][y] != 0
    end

    no_duplicate?(a)
  end


  def check_column_with_value(y, v)
    a = []
    a << v
    (0..8).each do |x|
      a << @board[x][y] unless @board[x][y] == 0
    end

    no_duplicate?(a)
  end


  def all_filled?(a)
    a.size == 9
  end


  def no_duplicate?(a)
    a.uniq.length == a.length
  end


  def assign_value(x, y, v)
  end


  def clear_value(x, y)
    @board[x][y] = 0
  end


  def print_current_board
    puts "Current Board: "
    print_board(@board)
  end


  def print_initial_board
    puts "Initial Board: "
    print_board(@initial_board)
  end


  def print_zero_board
    puts "Empty Board: "
    print_board(@@zero_board)
  end


  def print_board(board)

    (0..8).each do |i|
      puts if (i % 3 == 0)

      (0..8).each do |j|
        print " | " if (j % 3 == 0)
        print " "
        print board[i][j]
        print " "
      end

      puts " | "
    end
    puts
  end


  def solve
    reset_board
    x, y = choose_starting_point
    search(x, y)
  end


  def choose_starting_point
    return 0, 0
  end


  def search(x, y)
  end


  def solve_all
    solve_time(@@easy, "Easy")
    solve_time(@@medium, "Medium")
    solve_time(@@hard, "Hard")
    solve_time(@@evil, "Evil")
  end


  def solve_time(board, level)
    setup(board)

    time = Benchmark.measure do
      solve
    end

    puts "Solved #{level}: #{solved?}, #{@node_searched} node searched"
    puts "Time: #{time}"
    puts
  end



  @@easy   = [[9, 0, 4, 0, 0, 0, 0, 5, 8],
              [0, 0, 0, 1, 0, 0, 0, 9, 7],
              [0, 0, 1, 8, 0, 0, 4, 0, 6],
              [0, 0, 0, 6, 0, 0, 0, 4, 0],
              [0, 5, 0, 4, 0, 9, 0, 1, 0],
              [0, 9, 0, 0, 0, 1, 0, 0, 0],
              [5, 0, 6, 0, 0, 4, 3, 0, 0],
              [3, 4, 0, 0, 0, 8, 0, 0, 0],
              [7, 8, 0, 0, 0, 0, 9, 0, 4]]

  @@medium = [[0, 0, 5, 0, 2, 0, 0, 0, 4],
              [0, 0, 0, 9, 0, 1, 0, 0, 6],
              [9, 4, 0, 0, 7, 0, 0, 2, 0],
              [4, 8, 0, 7, 0, 0, 0, 9, 3],
              [0, 0, 0, 0, 0, 0, 0, 0, 0],
              [7, 5, 0, 0, 0, 4, 0, 1, 8],
              [0, 3, 0, 0, 1, 0, 0, 5, 9],
              [5, 0, 0, 2, 0, 8, 0, 0, 0],
              [6, 0, 0, 0, 5, 0, 3, 0, 0]]

  @@hard   = [[2, 0, 0, 9, 0, 4, 0, 0, 0],
              [3, 4, 6, 0, 8, 0, 0, 0, 0],
              [9, 0, 0, 3, 6, 2, 0, 0, 0],
              [0, 0, 3, 0, 0, 0, 0, 5, 0],
              [8, 0, 5, 0, 0, 0, 1, 0, 9],
              [0, 6, 0, 0, 0, 0, 3, 0, 0],
              [0, 0, 0, 2, 1, 9, 0, 0, 6],
              [0, 0, 0, 0, 4, 0, 9, 3, 8],
              [0, 0, 0, 8, 0, 7, 0, 0, 2]]

  @@evil   = [[0, 2, 0, 0, 0, 8, 6, 0, 0],
              [8, 0, 0, 0, 0, 7, 0, 0, 0],
              [0, 7, 3, 0, 4, 0, 0, 0, 0],
              [2, 0, 0, 0, 0, 5, 0, 9, 0],
              [5, 0, 0, 6, 0, 9, 0, 0, 4],
              [0, 8, 0, 3, 0, 0, 0, 0, 5],
              [0, 0, 0, 0, 9, 0, 3, 1, 0],
              [0, 0, 0, 2, 0, 0, 0, 0, 7],
              [0, 0, 2, 4, 0, 0, 0, 8, 0]]


end


