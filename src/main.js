define(["./var/isInteger", "lodash", "async", "board", "coordinate"], function(isInteger, _, async, Board, coordinate_trans) {
  var Goban;
  Goban = (function() {
    var BLACK, EMPTY, WHITE, externalColor, internalColor, normalizeCoord, setupConfig, _place, _set;

    Goban.VERSION = '0.1.0';

    EMPTY = 0;

    BLACK = 1;

    WHITE = 2;

    function Goban(row, col) {
      var worker;
      this.row = row != null ? row : 19;
      this.col = col;
      /*
      vars:
      - row
      - col (rows)
      - history
      - play_history
      - board_state
      - config
      */

      /*
      1. no args:
          @row = @col = 19
      
      2. one arg (i.e. @row):
          @col := @row
      
      3. two arg: trivial
      */

      if (this.col == null) {
        this.col = this.row;
      }
      if (!isInteger(this.row)) {
        throw new Error("First param of Goban (row) must be an integer");
      }
      if (!isInteger(this.col)) {
        throw new Error("Second param of Goban (col) must be an integer");
      }
      if (this.row <= 0) {
        throw new Error("First param of Goban (row) must be at least 1");
      }
      if (this.col <= 0) {
        throw new Error("Second param of Goban (col) must be at least 1");
      }
      setupConfig.call(this);
      this.history = {};
      this.play_history = [];
      this.board = new Board(this.row, this.col, EMPTY);
      this.board_state = {};
      worker = function(_work, callback) {
        var _args, _f, _this;
        _f = _work['f'];
        _this = _work['_this'];
        _args = _work['_args'] || [];
        _args.push(callback);
        return _f.apply(_this, _args);
      };
      this.queue = async.queue(worker, 1);
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
      if (opts == null) {
        opts = void 0;
      }
      if (opts === void 0) {
        return this._config;
      }
      if (!_.isPlainObject(opts)) {
        throw new Error('Attempt to load Goban config that is not a plain object.');
      }
      this._config = _.assign({}, this._config, opts);
      return this;
    };

    normalizeCoord = function(first, second) {
      var col, coord_trans_func, coordinates, data, func, row, _ref;
      coordinates = this._config['coordinate_system_transformations'];
      coord_trans_func = coordinates[this._config['coordinate_system']];
      if (_.isFunction(coord_trans_func)) {
        data = {};
        data['row_bound'] = this.row;
        data['col_bound'] = this.col;
        func = _.bind(coord_trans_func, data, first, second);
        _ref = func(), row = _ref[0], col = _ref[1];
        if (!isInteger(row) || !isInteger(col)) {
          throw new Error("Transformation via coordinate system '" + this._config['coordinate_system'] + "' failed.");
        }
        return [row, col];
      } else {
        throw new Error('Invalid configuration property: "coordinate_system". Given #{@_config[\'coordinate_system\']}');
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
      _ref = normalizeCoord.call(this, first, second), row = _ref[0], col = _ref[1];
      if (!((0 <= col && col < this.col)) || !((0 <= row && row < this.row))) {
        throw new Error('Goban.get() parameter(s) is/are out of bounds.');
      }
      color = this.board.get(row, col);
      try {
        return externalColor.call(this, color);
      } catch (_error) {
        error = _error;
        throw new Error("Goban.get(x, y) is broken!");
      }
    };

    _set = function(_color, _first, _second, _callback, queue_callback) {
      var meta_function, meta_function2, state, waterfall_cb, _callback_f, _change_pos_f, _color_f, _first_second_f, _get_old_color_f, _norm_coord_validate_f, _stone_place_f,
        _this = this;
      if (_color == null) {
        _color = void 0;
      }
      if (_first == null) {
        _first = void 0;
      }
      if (_second == null) {
        _second = void 0;
      }
      if (_callback == null) {
        _callback = void 0;
      }
      if (_callback === void 0) {
        _callback = function() {};
      }
      state = {};
      state['affected'] = void 0;
      state['attempt'] = void 0;
      state['callback'] = _callback;
      state['color'] = _color;
      state['first'] = _first;
      state['second'] = _second;
      state['queue_callback'] = queue_callback;
      _callback_f = function(state, callback) {
        var __callback;
        __callback = state['callback'];
        state['callback'] = _.compose(queue_callback, _callback);
        return callback(null, state);
      };
      _color_f = function(state, callback) {
        var err;
        _color = state['color'];
        err = void 0;
        if (_color === void 0) {
          err = new Error("No color give for Goban.set()");
        }
        return callback(err, state);
      };
      _first_second_f = function(state, callback) {
        var err;
        _first = state['first'];
        _second = state['second'];
        err = void 0;
        if (_first === void 0 || _second === void 0) {
          err = new Error("Invalid coordinate for Goban.set()");
        }
        return callback(err, state);
      };
      _stone_place_f = function(state, callback) {
        var attempt, color, err, error;
        _color = state['color'];
        attempt = {};
        attempt['color'] = _color;
        attempt['coord'] = [state['first'], state['second']];
        state['attempt'] = attempt;
        err = void 0;
        color = void 0;
        try {
          state['internal_color'] = internalColor.call(_this, _color);
        } catch (_error) {
          error = _error;
          err = new Error("Invalid color for Goban.set(). Given: " + _color);
        }
        return callback(err, state);
      };
      _norm_coord_validate_f = function(state, callback) {
        var col, err, error, row, _ref;
        state['row'] = state['col'] = void 0;
        err = void 0;
        try {
          _ref = normalizeCoord.call(_this, state['first'], state['second']), row = _ref[0], col = _ref[1];
          state['row'] = row;
          state['col'] = col;
        } catch (_error) {
          error = _error;
          callback(error, state);
        }
        if (!((0 <= col && col < _this.col)) || !((0 <= row && row < _this.row))) {
          err = new Error('Goban.set() coord parameter(s) is/are out of bounds.');
        }
        return callback(err, state);
      };
      _get_old_color_f = function(state, callback) {
        state['_old_color'] = _this.board.get(state['row'], state['col']);
        state['ex_old_color'] = externalColor.call(_this, state['_old_color']);
        return callback(null, state);
      };
      _change_pos_f = function(state, callback) {
        var affected;
        _this.board.set(state['internal_color'], state['row'], state['col']);
        affected = {};
        affected[state['ex_old_color']] = {};
        affected[state['ex_old_color']][state['color']] = [];
        affected[state['ex_old_color']][state['color']].push([state['first'], state['second']]);
        state['affected'] = affected;
        return callback(null, state);
      };
      meta_function = _.bind(function(state, callback) {
        return callback(null, state);
      }, this, state);
      meta_function2 = function(callback___) {
        return callback___(null, state);
      };
      waterfall_cb = function(err, state) {
        return state['callback'](err, state['attempt'], state['affected']);
      };
      async.waterfall([meta_function, _callback_f, _color_f, _first_second_f, _stone_place_f, _norm_coord_validate_f, _get_old_color_f, _change_pos_f], waterfall_cb);
    };

    Goban.prototype.set = function(_color, first, second, callback) {
      var work_package;
      work_package = {
        f: _set,
        _this: this,
        _args: [_color, first, second, callback]
      };
      this.queue.push(work_package);
      return this;
    };

    _place = function(_color, first, second, callback, queue_callback) {
      if (_color == null) {
        _color = void 0;
      }
      if (first == null) {
        first = void 0;
      }
      if (second == null) {
        second = void 0;
      }
      if (callback == null) {
        callback = void 0;
      }
    };

    Goban.prototype.place = function(_color, first, second, callback) {
      var work_package;
      work_package = {
        f: _place,
        _this: this,
        _args: [_color, first, second, callback]
      };
      this.queue.push(work_package);
      return this;
    };

    return Goban;

  })();
  return Goban;
});
