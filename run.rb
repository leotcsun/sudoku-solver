require_relative "sudoku"
require_relative "sudoku_bt"
require_relative "sudoku_bt_fc"
require_relative "sudoku_bt_fc_h"

puts "Solving with Back Tracking ============================================="
solver_bt = SudokuBt.new
solver_bt.solve_all
puts

puts "Solving with Back Trackig & Forward Checking ==========================="
solver_bt_fc = SudokuBtFc.new
solver_bt_fc.solve_all
puts

puts "Solving with Back Tracking & ForwardChecking & Heuristics =============="

solver_bt_fc_h = SudokuBtFcH.new
solver_bt_fc_h.solve_all
puts
