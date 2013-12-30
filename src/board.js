define(["lodash"], function(_) {
  /*
  Represent the board in 1D array.
  
  1D array is get/set in row-major order.
  */

  var Board;
  Board = (function() {
    function Board(row, col, value) {
      this.row = row;
      this.col = col;
      if (this.col == null) {
        this.col = this.row;
      }
      this.board = [];
      if (value) {
        this.setDefault(value);
      }
    }

    Board.prototype.setDefault = function(value) {
      var n;
      n = this.row * this.col;
      while (n-- > 0) {
        this.board.push(value);
      }
      return this;
    };

    Board.prototype.getBoard = function() {
      return this.board;
    };

    Board.prototype.get = function(row, col) {
      return this.board[row * this.col + col];
    };

    Board.prototype.set = function(value, row, col) {
      this.board[row * this.col + col] = value;
      return this;
    };

    return Board;

  })();
  return Board;
});
