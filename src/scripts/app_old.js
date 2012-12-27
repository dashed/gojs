requirejs.config({
baseUrl: "scripts",
enforceDefine: true,
urlArgs: "bust=" +  (new Date()).getTime(),
paths: {
    'raphael': 'libs/raphael/raphael.amd',
    'eve': 'libs/raphael/eve',
    'raphael.core': 'libs/raphael/raphael.core',
    'raphael.svg': 'libs/raphael/raphael.svg',
    'raphael.vml': 'libs/raphael/raphael.vml',
    'domReady': 'helper/domReady',
    'jquery': 'http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min',
    'underscore': 'libs/underscore-min'
},
shim: {
        'raphael': {
            exports: 'Raphael'
        },
        'jquery': {
            exports: '$'
        },
        'underscore': {
            exports: '_'
        }
}
});

define(['cs!app'], function() {

});

define(['raphael','jquery','underscore', 'domReady!'], function (Raphael, $) {
  
    //This function is called once the DOM is ready.
    //It will be safe to query the DOM and manipulate
    //DOM nodes in this function.

	$("#canvas").html('l');

var range = function(start, end, step) {
    var range = [];
    var typeofStart = typeof start;
    var typeofEnd = typeof end;

    if (step === 0) {
        throw TypeError("Step cannot be zero.");
    }

    if (typeofStart == "undefined" || typeofEnd == "undefined") {
        throw TypeError("Must pass start and end arguments.");
    } else if (typeofStart != typeofEnd) {
        throw TypeError("Start and end arguments must be of same type.");
    }

    typeof step == "undefined" && (step = 1);

    if (end < start) {
        step = -step;
    }

    if (typeofStart == "number") {

        while (step > 0 ? end >= start : end <= start) {
            range.push(start);
            start += step;
        }

    } else if (typeofStart == "string") {

        if (start.length != 1 || end.length != 1) {
            throw TypeError("Only strings with one character are supported.");
        }

        start = start.charCodeAt(0);
        end = end.charCodeAt(0);

        while (step > 0 ? end >= start : end <= start) {
            range.push(String.fromCharCode(start));
            start += step;
        }

    } else {
        throw TypeError("Only string and number types are supported");
    }

    return range;

}

	var num_string = function(num) {
		return num.toString();
	}

	// measurement
	//paper.rect(0,0, raph_x,raph_x);

	var cell_radius = 25;
	var n = 19; // n X n board
	var text_size = 15; //pixels

	var text_buffer = text_size+cell_radius/2+10;
	var text_movement = cell_radius/2 + text_size/2 + 5;
	
	var raph_x = cell_radius*(n-1)+text_buffer*2;
	var paper = Raphael(25,25, raph_x, raph_x);
	
	var circle_radius = 0.50*cell_radius;

	// marks top-left point 
	var y = text_buffer*1; // top-left x
	var x = y; // top-left y

	// construct the board
	var board_outline = paper.rect(x, y, cell_radius*(n-1), cell_radius*(n-1)).attr('stroke-width',1);
	paper.rect(x, y, cell_radius*(n-1), cell_radius*(n-1)).attr('stroke-width',1);


	// text labels
	_.each(range(0, n-1), function(letter, index) {

		var letter = String.fromCharCode(65+index);

		paper.text(x+cell_radius*(index), y+cell_radius*(n-1) + text_movement, letter).attr("font-size", text_size);
		paper.text(x+cell_radius*(index), y-text_movement, letter).attr("font-size", text_size);
	});

	_.each(range(1, n), function(letter, index) {
		paper.text(x - text_movement, y+cell_radius*(n-1-index), letter).attr("font-size", text_size);
		paper.text(x +cell_radius*(n-1) + text_movement, y+cell_radius*(n-1-index), letter).attr("font-size", text_size);
	});

	// construct lines
	for(var i=0; i < n - 2; i++) {
		var line_vert = paper.path("M"+ num_string(x+cell_radius*(i+1)) +","+ num_string(y+cell_radius*(n-1)) +"V" + num_string(y));
		var line_horiz = paper.path("M"+ x +","+ num_string(y+cell_radius*(i+1)) +"H" + num_string(x+cell_radius*(n-1)));
	}

	// Star point markers (handicap markers)
	// See: http://senseis.xmp.net/?Hoshi
	(function() {

		var generate_star = function(_x,_y) {

			var handicap = paper.circle(x+cell_radius*_x, y+cell_radius*_y, 0.15*circle_radius);
			handicap.attr("fill", "#000");
		}
		
		if(n === 19) {

			generate_star(3,3);
			generate_star(9,3);
			generate_star(15,3);

			generate_star(3,9);
			generate_star(9,9);
			generate_star(15,9);

			generate_star(3,15);
			generate_star(9,15);
			generate_star(15,15);
		} else if(n === 13) {

			generate_star(3,3);
			generate_star(9,3);

			generate_star(6,6);

			generate_star(3,9);
			generate_star(9,9);

		} else if(n === 9) {

			generate_star(2,2);
			generate_star(6,2);

			generate_star(4,4);

			generate_star(2,6);
			generate_star(6,6);

		}

	})();


	// Populate with stones
	var white_stone = function(i,j) {

		var _x = x+cell_radius*i;
		var _y = y+cell_radius*j;

		var circle2 = paper.circle(_x, _y, circle_radius);
		circle2.attr("fill", "#fff");
		circle2.attr("stroke-width", "0");	

		var circle = paper.circle(_x,_y,circle_radius);
	
		circle.attr("fill", "r(0.75,0.75)#fff-#A0A0A0");
		circle.attr("fill-opacity", 1);
		circle.attr("stroke-opacity", 0.3);
		circle.attr("stroke-width", "1.1");	
	}

	var black_stone = function(i,j) {

		var _x = x+cell_radius*i;
		var _y = y+cell_radius*j;

		var circle2 = paper.circle(_x, _y, circle_radius);
		circle2.attr("fill", "#fff");
		circle2.attr("stroke-width", "0");	

		var circle = paper.circle(_x,_y,circle_radius);
	
		circle.attr("fill-opacity", 0.9);
		circle.attr("fill", "r(0.75,0.75)#A0A0A0-#000");
		circle.attr("stroke-width", "1.2");	
	}

	// tracks move made
	var track_stone_pointer = null;
	var track_stone = function(i,j) {
		var _x = x+cell_radius*i;
		var _y = y+cell_radius*j;
		if(track_stone_pointer != null) {
			track_stone_pointer.remove();
		}
		track_stone_pointer = paper.circle(_x,_y,circle_radius/2);
		track_stone_pointer.attr("stroke", "red");
		track_stone_pointer.attr("stroke-width", "2");	
	}

	// Put stones on board if user has clicked

	var group = paper.set();

	_.each(_.range(n), function(i, index) {
		_.each(_.range(n), function(j, index) {


			var clicker = paper.rect(x-cell_radius/2+cell_radius*i, y-cell_radius/2+cell_radius*j, cell_radius, cell_radius);
			clicker.attr("fill", "#fff");
			clicker.attr("stroke-width", "0");
			clicker.attr("fill-opacity", 0);
			clicker.data("coord", [i,j]);
			group.push(clicker);
			
		});
	});

	// Replicate board as a multidimensional array

	var EMPTY = 0;
	var BLACK = 1;
	var WHITE = 2;

	var virtual_board = new Array(n);
	_.each(_.range(n), function(i) {
		virtual_board[i] = new Array(n);
		_.each(_.range(n), function(j) {
			virtual_board[i][j] = EMPTY;
		});
	});

	// Game engine

	var get_neighbours = function(_x, _y) {
		neighbours = [];

		if (_x > 0) neighbours.push([_x - 1, _y]);
        if (_x < n - 1) neighbours.push([_x + 1, _y]);
        if (_y > 0) neighbours.push([_x, _y - 1]);
        if (_y < n - 1) neighbours.push([_x, _y + 1]);

        return neighbours;
	}

	var get_liberties = function(_x, _y, _board) {
		var liberties = {};
		var point_color = _board[_x, _y];

		var flood_fill_color = EMPTY;

		// Switch to an opposite colour
		switch(point_color) {
			case EMPTY:
				flood_fill_color = EMPTY;
				break;
			case WHITE:
				flood_fill_color = BLACK;
				break;
			case BLACK:
				flood_fill_color = WHITE;
				break;
			default:
				flood_fill_color = EMPTY;
		}


		_board[_x, _y] = flood_fill_color;

		var neighbours = get_neighbours(_x, _y);
		_.each(neighbours, function(neighbour) {

			if (_board[neighbour[0],neighbour[1]] === point_color) {

		        _.each(get_liberties(neighbour[0],neighbour[1]), function(neighbour) {
					liberties[neighbour] = true;		        	
		        });

			} else if (_board[neighbour[0],neighbour[1]] === EMPTY) {

				liberties[neighbour] = true;

			}

		});

		return liberties;
	}

	var in_atari = function(_x, _y) {

		// Deep copy virtual board
		var virtual_board_clone = $.extend(true, [], virtual_board);


		return _.size(get_liberties(_x, _y, virtual_board_clone)) == 1 && console.log(virtual_board_clone);

	}

	var koPoint = [];

	// determine if the move is legal
	var is_legal = function(_x, _y, _color) {

		// Is the point already occupied?
		if (virtual_board[_x, _y] != EMPTY) {
			return false;
		}

		// Is the move ko?
		if (koPoint[0] === _x && koPoint[1] === _y) {
			return false;
		}

		// Is the move suicide?
		var suicide = true;

		// Switch to an opposite colour
		var _color_opp = EMPTY;
		switch(_color) {
			case EMPTY:
				_color_opp = EMPTY;
				break;
			case WHITE:
				_color_opp = BLACK;
				break;
			case BLACK:
				_color_opp = WHITE;
				break;
			default:
				_color_opp = EMPTY;
		}

		_.each(get_neighbours(_x, _y), function(neighbour){

			var n_x = neighbour[0];
			var n_y = neighbour[1];

			var neighbour_color = virtual_board[n_x, n_y];
			if (neighbour_color === EMPTY) {
				// if any neighbor is VACANT, suicide = false
				suicide = false;
			} else if (neighbour_color == _color) {
				// if any neighbor is an ally
				// that isn't in atari
				if (!in_atari(n_x, n_y)) {
					suicide = false;
				}
			} else if (neighbour_color == _color_opp) {
				// if any neighbor is an enemy
				// and that enemy is in atari
				if (in_atari(n_x, n_y)) {
					suicide = false;
				}
			}
		});

	// If the point is not occupied, the move is not ko, and not suicide
	// it is a legal move.

	return !suicide;


	}



	var current_stone = BLACK;

	group.mouseover(function(e) {

		var coord = this.data("coord");
		//console.log(get_neighbours(coord[0], coord[1]));

	}).mouseup(function(e) {

		var coord = this.data("coord");
		if(virtual_board[coord[0]][coord[1]] === EMPTY) {

			if(current_stone === BLACK) {

				virtual_board[coord[0]][coord[1]] = BLACK;
				black_stone(coord[0], coord[1]);
				current_stone = WHITE;
				track_stone(coord[0], coord[1]);

			} else {

				virtual_board[coord[0]][coord[1]] = WHITE;
				white_stone(coord[0], coord[1]);
				current_stone = BLACK;
				track_stone(coord[0], coord[1]);
			}

			
		}


	});


/*
	
	_.each(range(0, n-1,2), function(i, index) {
		_.each(range(0, n-1,2), function(j, index) {

			white_stone(i, j);
			
		});
	});

	_.each(range(1, n-1,2), function(i, index) {
		_.each(range(1, n-1,2), function(j, index) {

			white_stone(i, j);
	
		});
	});


	_.each(range(1, n-1,2), function(i, index) {
		_.each(range(0, n-1,2), function(j, index) {

			black_stone(i,j);
		});
	});
	_.each(range(0, n-1,2), function(i, index) {
		_.each(range(1, n-1,2), function(j, index) {

			black_stone(i,j);
		});
	});
*/


	paper.safari();
	paper.renderfix();


});

