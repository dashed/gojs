// Generated by CoffeeScript 1.3.3

define(["underscore"], function(_) {
  var Board, _Board;
  Board = (function() {
    var _instance;

    function Board() {}

    _instance = void 0;

    Board.get = function(size) {
      return _instance != null ? _instance : _instance = new _Board(size);
    };

    return Board;

  })();
  _Board = (function() {

    _Board.EMPTY = 0;

    _Board.BLACK = 1;

    _Board.WHITE = 2;

    _Board.CURRENT_STONE = _Board.BLACK;

    function _Board(size) {
      var get_this;
      this.size = size;
      this.EMPTY = 0;
      this.BLACK = 1;
      this.WHITE = 2;
      this.CURRENT_STONE = this.BLACK;
      if (typeof this.size !== "number") {
        this.size = 0;
      }
      get_this = this;
      this.virtual_board = new Array(this.size);
      _.each(_.range(this.size), function(i) {
        get_this.virtual_board[i] = new Array(get_this.size);
        return _.each(_.range(get_this.size), function(j) {
          return get_this.virtual_board[i][j] = get_this.EMPTY;
        });
      });
      return;
    }

    _Board.prototype.move = function(_coord) {
      var move_results, point, _x, _y;
      _x = _coord[0];
      _y = _coord[1];
      point = this.virtual_board[_x][_y];
      move_results = {
        color: this.EMPTY,
        x: _x,
        y: _y
      };
      if (point === this.EMPTY) {
        if (this.CURRENT_STONE === this.BLACK) {
          this.virtual_board[_x][_y] = this.BLACK;
          move_results.color = this.BLACK;
          this.CURRENT_STONE = this.WHITE;
        } else {
          this.virtual_board[_x][_y] = this.WHITE;
          move_results.color = this.WHITE;
          this.CURRENT_STONE = this.BLACK;
        }
      }
      return move_results;
    };

    return _Board;

  })();
  return Board;
});
