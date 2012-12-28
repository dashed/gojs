// Generated by CoffeeScript 1.3.3

requirejs.config({
  baseUrl: "scripts",
  enforceDefine: true,
  urlArgs: "bust=" + (new Date()).getTime(),
  paths: {
    "raphael": "libs/raphael/raphael.amd",
    "eve": "libs/raphael/eve",
    "raphael.core": "libs/raphael/raphael.core",
    "raphael.svg": "libs/raphael/raphael.svg",
    "raphael.vml": "libs/raphael/raphael.vml",
    "domReady": "helper/domReady",
    "jquery": "http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min",
    "underscore": "libs/underscore-min",
    "murmurhash3": "libs/murmurhash3",
    "Board": "Board"
  },
  shim: {
    raphael: {
      exports: "Raphael"
    },
    'raphael.scale': {
      exports: "RaphaelScale"
    },
    jquery: {
      exports: "$"
    },
    underscore: {
      exports: "_"
    },
    murmurhash3: {
      exports: "murmurhash3"
    }
  }
});

define(["raphael", "jquery", "underscore", "murmurhash3", "Board", "domReady!"], function(Raphael, $, _, murmurhash3, Board) {
  var lol, _GoBoard;
  lol = 'hello';
  console.log(murmurhash3.hashString(lol, lol.length, +new Date()));
  return _GoBoard = (function() {

    function _GoBoard(container, container_size, board_size) {
      this.container = container;
      this.container_size = container_size;
      this.board_size = board_size;
      this.RAPH_BOARD_STATE = {};
      if (typeof this.container !== "string" || typeof this.container_size !== "number") {
        return;
      }
      if (this.container_size < 0) {
        return;
      }
      if (typeof this.board_size !== "number" || this.board_size > 19) {
        this.board_size = 19;
      }
      if (this.board_size < 0) {
        this.board_size = 0;
      }
      this.canvas = $("#" + this.container.toString());
      this.draw_board();
    }

    _GoBoard.prototype.draw_board = function() {
      var black_stone, board_outline, canvas, canvas_length, cell_radius, circle_radius, get_this, group, i, length, line_horiz, line_vert, n, paper, remove_stone, text_buffer, text_movement, text_size, track_stone, track_stone_pointer, virtual_board, white_stone, x, y;
      canvas = this.canvas;
      canvas.css('overflow', 'hidden');
      canvas.css('display', 'block');
      canvas.css('border', '1px solid black');
      canvas = this.canvas;
      n = this.board_size;
      cell_radius = 25;
      circle_radius = 0.50 * cell_radius;
      text_size = 15;
      text_buffer = text_size + cell_radius / 2 + 20;
      text_movement = text_buffer / 2;
      canvas_length = cell_radius * (n - 1) + text_buffer * 2;
      paper = Raphael(canvas[0], canvas_length, canvas_length);
      y = text_buffer * 1;
      x = text_buffer;
      board_outline = paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr("stroke-width", 2);
      paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr("stroke-width", 1);
      _.each(_.range(n), function(letter, index) {
        letter = String.fromCharCode(65 + index);
        paper.text(x + cell_radius * index, y + cell_radius * (n - 1) + text_movement, letter).attr("font-size", text_size);
        return paper.text(x + cell_radius * index, y - text_movement, letter).attr("font-size", text_size);
      });
      _.each(_.range(1, n + 1), function(letter, index) {
        paper.text(x - text_movement, y + cell_radius * (n - 1 - index), letter).attr("font-size", text_size);
        return paper.text(x + cell_radius * (n - 1) + text_movement, y + cell_radius * (n - 1 - index), letter).attr("font-size", text_size);
      });
      i = 0;
      while (i < n - 2) {
        line_vert = paper.path("M" + (x + cell_radius * (i + 1)) + "," + (y + cell_radius * (n - 1)) + "V" + y);
        line_horiz = paper.path("M" + x + "," + (y + cell_radius * (i + 1)) + "H" + (x + cell_radius * (n - 1)));
        i++;
      }
      (function() {
        var generate_star;
        generate_star = function(_x, _y) {
          var handicap;
          handicap = paper.circle(x + cell_radius * _x, y + cell_radius * _y, 0.20 * circle_radius);
          return handicap.attr("fill", "#000");
        };
        if (n === 19) {
          generate_star(3, 3);
          generate_star(9, 3);
          generate_star(15, 3);
          generate_star(3, 9);
          generate_star(9, 9);
          generate_star(15, 9);
          generate_star(3, 15);
          generate_star(9, 15);
          return generate_star(15, 15);
        } else if (n === 13) {
          generate_star(3, 3);
          generate_star(9, 3);
          generate_star(6, 6);
          generate_star(3, 9);
          return generate_star(9, 9);
        } else if (n === 9) {
          generate_star(2, 2);
          generate_star(6, 2);
          generate_star(4, 4);
          generate_star(2, 6);
          return generate_star(6, 6);
        }
      })();
      track_stone_pointer = null;
      track_stone = function(i, j) {
        var _x, _y;
        _x = x + cell_radius * i;
        _y = y + cell_radius * j;
        if (track_stone_pointer != null) {
          track_stone_pointer.remove();
        }
        track_stone_pointer = paper.circle(_x, _y, circle_radius / 2);
        track_stone_pointer.attr("stroke", "red");
        return track_stone_pointer.attr("stroke-width", "2");
      };
      white_stone = function(i, j) {
        var group, stone_bg, stone_fg, _x, _y;
        _x = x + cell_radius * i;
        _y = y + cell_radius * j;
        stone_bg = paper.circle(_x, _y, circle_radius);
        stone_bg.attr("fill", "#fff");
        stone_bg.attr("stroke-width", "0");
        stone_fg = paper.circle(_x, _y, circle_radius);
        stone_fg.attr("fill", "r(0.75,0.75)#fff-#A0A0A0");
        stone_fg.attr("fill-opacity", 1);
        stone_fg.attr("stroke-opacity", 0.3);
        stone_fg.attr("stroke-width", "1.1");
        track_stone(i, j);
        group = [];
        group.push(stone_bg.id);
        group.push(stone_fg.id);
        return group;
      };
      black_stone = function(i, j) {
        var group, stone_bg, stone_fg, _x, _y;
        _x = x + cell_radius * i;
        _y = y + cell_radius * j;
        stone_bg = paper.circle(_x, _y, circle_radius);
        stone_bg.attr("fill", "#fff");
        stone_bg.attr("stroke-width", "0");
        stone_fg = paper.circle(_x, _y, circle_radius);
        stone_fg.attr("fill-opacity", 0.9);
        stone_fg.attr("fill", "r(0.75,0.75)#A0A0A0-#000");
        stone_fg.attr("stroke-opacity", 0.3);
        stone_fg.attr("stroke-width", "1.2");
        track_stone(i, j);
        group = [];
        group.push(stone_bg.id);
        group.push(stone_fg.id);
        return group;
      };
      group = paper.set();
      _.each(_.range(n), function(i, index) {
        return _.each(_.range(n), function(j, index) {
          var clicker;
          clicker = paper.rect(x - cell_radius / 2 + cell_radius * i, y - cell_radius / 2 + cell_radius * j, cell_radius, cell_radius);
          clicker.attr("fill", "#fff");
          clicker.attr("fill-opacity", 0);
          clicker.attr("opacity", 0);
          clicker.attr("stroke-width", 0);
          clicker.attr("stroke", "#fff");
          clicker.attr("stroke-opacity", 0);
          clicker.data("coord", [i, j]);
          return group.push(clicker);
        });
      });
      get_this = this;
      remove_stone = function(coord) {
        return _.each(get_this.RAPH_BOARD_STATE[coord], function(id) {
          return paper.getById(id).remove();
        });
      };
      virtual_board = new Board(n);
      get_this = this;
      group.mouseover(function(e) {
        var coord;
        return coord = this.data("coord");
      }).click(function(e) {
        var coord, move_results, raph_layer_ids;
        coord = this.data("coord");
        move_results = virtual_board.move(coord);
        _.each(move_results.dead, function(dead_stone) {
          return remove_stone(dead_stone);
        });
        switch (move_results.color) {
          case virtual_board.BLACK:
            raph_layer_ids = black_stone(move_results.x, move_results.y);
            get_this.RAPH_BOARD_STATE[coord] = raph_layer_ids;
            break;
          case virtual_board.WHITE:
            raph_layer_ids = white_stone(move_results.x, move_results.y);
            get_this.RAPH_BOARD_STATE[coord] = raph_layer_ids;
            break;
        }
        this.toFront();
      });
      /*
            # Fill board with all stones 
           
            _.each _.range(0, n, 2), (i, index) ->
              _.each _.range(0, n, 2), (j, index) ->
                white_stone i, j
      
      
            _.each _.range(1, n, 2), (i, index) ->
              _.each _.range(1, n, 2), (j, index) ->
                white_stone i, j
      
      
            _.each _.range(1, n, 2), (i, index) ->
              _.each _.range(0, n, 2), (j, index) ->
                black_stone i, j
      
      
            _.each _.range(0, n, 2), (i, index) ->
              _.each _.range(1, n, 2), (j, index) ->
                black_stone i, j
      */

      paper.safari();
      paper.renderfix();
      /*
            length = @container_size
            canvas.height(length)
            canvas.width(length)
      
            viewbox_length = canvas_length*canvas_length/canvas.width()
            paper.setViewBox(0, 0, viewbox_length*2, viewbox_length*2, true)
            paper.setSize(canvas_length*2,canvas_length*2)
      */

      length = this.container_size;
      canvas.height(length);
      canvas.width(length);
      paper.setViewBox(0, 0, canvas_length, canvas_length, false);
      paper.setSize(length, length);
      return _GoBoard;
    };

    return _GoBoard;

  })();
});
