# Sudoku Solver

3 sudoku solvers each with a slightly different implementation (and improvement)

---

### SudokuBt

This solver performs a backtrack search algorithm.


### SudokuBtFc

This solver utilizes forward checking on top of backtrack to decrease the number of expanded node.


### SodokuBtFcH

This solver further improves the previous solvers by adding in the 3 heruistics, namely the __Least Constraining Value__ heruistic, the __Minimum Remaining Value__ heruistic, and the __Degree__ heuristic. Detailed explainations can be found from the book [Artificial Intelligence: A Modern Approach](http://www.amazon.com/Artificial-Intelligence-Modern-Approach-Edition/dp/0136042597/ref=sr_1_1?ie=UTF8&qid=1349576653&sr=8-1&keywords=artificial+intelligence+a+modern+approach+3rd+edition)