define(["./var/isInteger", "lodash"], function(isInteger, _) {
  var Goban;
  Goban = (function() {
    var BLACK, EMPTY, WHITE, boardGet, boardSet, normalizeCoord, setupConfig;

    Goban.VERSION = '0.1.0';

    EMPTY = 0;

    BLACK = 1;

    WHITE = 2;

    function Goban(length, width) {
      var n;
      this.length = length != null ? length : 19;
      this.width = width;
      /*
      vars:
      - length
      - width
      - history
      - play_history
      - board_state
      - config
      */

      /*
      1. no args:
          @length = @width = 19
      
      2. one arg (i.e. @length):
          @width = @length
      
      3. two arg: trivial
      */

      if (this.width == null) {
        this.width = this.length;
      }
      if (!isInteger(this.length)) {
        throw new Error("First param of Goban (length) must be an integer");
      }
      if (!isInteger(this.width)) {
        throw new Error("Second param of Goban (width) must be an integer");
      }
      if (this.length <= 0) {
        throw new Error("First param of Goban (length) must be at least 1");
      }
      if (this.width <= 0) {
        throw new Error("Second param of Goban (width) must be at least 1");
      }
      setupConfig.call(this);
      this.history = {};
      this.play_history = [];
      this.board = [];
      this.board_state = {};
      n = this.length * this.width;
      while (n-- > 0) {
        this.board.push(EMPTY);
      }
      return;
    }

    setupConfig = function() {
      var _config;
      _config = {};
      _config['stone'] = {
        'EMPTY': 'empty',
        'BLACK': 'black',
        'WHITE': 'white'
      };
      /*
      values: japanese, western, matrix, cartesian
      See: http://senseis.xmp.net/?Coordinates
      
      matrix: from top-left to bottom-right
      cartesian: from bottom-left to top-right
      */

      _config['coordinate_system'] = 'western';
      this._config = _config;
    };

    Goban.prototype.config = function(opts) {
      if (!_.isPlainObject(opts)) {
        throw new Error('Attempt to load Goban config that is not a plain object.');
      }
      this._config = _.assign({}, this._config, opts);
      return this;
    };

    Goban.prototype.getConfig = function() {
      return this._config;
    };

    /*
    (x,y) is assumed to be relative to bottom-left corner.
    x and y are 0-based index.
    */


    normalizeCoord = function(x, y) {
      var _y;
      _y = y - (this.length - 1);
      if (_y < 0) {
        _y *= -1;
      }
      return [x, _y];
    };

    /*
    Note: origin (0,0) is bottom-left corner
    */


    boardGet = function(x, y) {};

    /*
    Note: origin (0,0) is bottom-left corner
    */


    boardSet = function(color, x, y) {};

    Goban.prototype.get = function(x, y) {
      /*
      length => cols
      width => rows
      */

      var color, _ref, _x, _y;
      _ref = normalizeCoord(x, y), _x = _ref[0], _y = _ref[1];
      color = this.board[this.length * _y + _x];
      switch (color) {
        case EMPTY:
          return this._config['stone']['EMPTY'];
        case BLACK:
          return this._config['stone']['BLACK'];
        case WHITE:
          return this._config['stone']['WHITE'];
        default:
          throw new Error("Goban.get(x,y) is broken!");
      }
    };

    Goban.prototype.set = function(_color, _x, _y, callback) {
      var color, x, y, _ref;
      _ref = normalizeCoord(_x, _y), x = _ref[0], y = _ref[1];
      color = void 0;
      if (_color !== this._config['stone']['EMPTY'] && _color !== this._config['stone']['BLACK'] && _color !== this._config['stone']['WHITE']) {
        throw new Error("Invalid color for Goban.set(x,y)");
      } else {
        color = _color;
      }
      callback();
      return this;
    };

    Goban.prototype.place = function(color, x, y, callback) {
      return this;
    };

    return Goban;

  })();
  return Goban;
});
