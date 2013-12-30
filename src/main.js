define(["./var/isInteger", "lodash", "board", "coordinate"], function(isInteger, _, Board, coordinate_trans) {
  var Goban;
  Goban = (function() {
    var BLACK, EMPTY, WHITE, externalColor, internalColor, normalizeCoord, setupConfig;

    Goban.VERSION = '0.1.0';

    EMPTY = 0;

    BLACK = 1;

    WHITE = 2;

    function Goban(length, width) {
      this.length = length != null ? length : 19;
      this.width = width;
      /*
      vars:
      - length (cols)
      - width (rows)
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
      this.board = new Board(this.length, this.width, EMPTY);
      this.board_state = {};
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

      _config['coordinate_system'] = 'cartesian_one';
      _config['coordinate_system_transformations'] = coordinate_trans;
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

    normalizeCoord = function(first, second) {
      var col, coord, coordinate, data, func, row, _ref;
      coordinate = this.config['coordinate_system_transformations'];
      coord = coordinate[this.config['coordinate_system']];
      if (_.isFunction(coord)) {
        data = {};
        data['row_bound'] = this.width;
        data['col_bound'] = this.length;
        func = _.bind(coord, data, first, second);
        _ref = func(), row = _ref[0], col = _ref[1];
        if (!isInteger(row) || !isInteger(col)) {
          throw new Error("Transformation via coordinate system '" + this.config['coordinate_system'] + "' failed.");
        }
        return [row, col];
      } else {
        throw new Error('Invalid configuration property: "coordinate_system".');
      }
    };

    internalColor = function(external_color) {
      switch (external_color) {
        case this._config['stone']['EMPTY']:
          return EMPTY;
        case this._config['stone']['BLACK']:
          return BLACK;
        case this._config['stone']['WHITE']:
          return WHITE;
        default:
          throw new Error("Invalid external color");
      }
    };

    externalColor = function(internal_color) {
      switch (internal_color) {
        case EMPTY:
          return this._config['stone']['EMPTY'];
        case BLACK:
          return this._config['stone']['BLACK'];
        case WHITE:
          return this._config['stone']['WHITE'];
        default:
          throw new Error("Invalid internal color");
      }
    };

    Goban.prototype.get = function(first, second) {
      var col, color, error, row, _ref;
      _ref = normalizeCoord(this, first, second), row = _ref[0], col = _ref[1];
      if (!((0 <= col && col <= (this.length - 1))) || !((0 <= row && row <= (this.width - 1)))) {
        throw new Error('Goban.get() parameter(s) is/are out of bounds.');
      }
      color = this.board.get(row, col);
      try {
        return external_color.call(this, color);
      } catch (_error) {
        error = _error;
        throw new Error("Goban.get(x,y) is broken!");
      }
    };

    Goban.prototype.set = function(_color, first, second, callback) {
      var affected, attempt, col, color, err, error, ex_old_color, row, _old_color, _ref;
      color = void 0;
      try {
        color = internal_color.call(this, _color);
      } catch (_error) {
        error = _error;
        throw new Error("Invalid color for Goban.set(x,y)");
      }
      attempt = {};
      attempt['color'] = _color;
      attempt['coord'] = [first, second];
      _ref = normalizeCoord(this, first, second), row = _ref[0], col = _ref[1];
      err = void 0;
      if (!((0 <= col && col < this.length)) || !((0 <= row && row < this.width))) {
        err = new Error('Goban.set() coord parameter(s) is/are out of bounds.');
        callback(err, attempt, null);
        return this;
      }
      _old_color = this.board.get(row, col);
      ex_old_color = internal_color.call(this, _old_color);
      this.board.set(color, row, col);
      affected = {};
      affected[ex_old_color] = {};
      affected[ex_old_color][_color] = [first, second];
      callback(err, attempt, affected);
      return this;
    };

    Goban.prototype.place = function(color, x, y, callback) {
      return this;
    };

    return Goban;

  })();
  return Goban;
});
