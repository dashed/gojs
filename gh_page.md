gojs
====

Go board game in Javascript.

syntax
======

`var some_var = GoBoard(container_id, length, board_size);`

* `container_id`: an element container with with a unique `id` attribute

* `length`: render the element container into a square of length `length`

* `board_size`: render the go board of grid `board_size` x `board_size`. Must be an integer between `2` and `19`.

usage
=====

1. Place `<script src="path/to/gojs.js"></script>` in the `head` element, or right before the `body` tag.

2.	Place an empty `div` container with a unique `id` attribute. A `div` element is preferred, but other elements such as `p` may be used.

	Example:
	`<div id="go_board"></div>` 

	**Note:** If the container is not empty, gojs will empty it!

3. 	Render the go board via

	`var go_board = GoBoard("go_board", 500, 19)`

demo
====

## 19 x 19 board


	var goboard = GoBoard("canvas", 500, 19);

<div id="canvas"></div>

## 9x9 board


	var goboard2 = GoBoard("canvas2", 200, 9);

<div id="canvas2"></div>

## 13x13 board


	var goboard3 = GoBoard("canvas3", 300, 13);

<div id="canvas3"></div>


## 16x16 board (non-standard)


	var goboard4 = GoBoard("canvas4", 400, 16);

<div id="canvas4"></div>


colophon
========

* All code excluding libraries are written in [coffeescript](http://coffeescript.org/) which compiles into JavaScript.

* [Raphael JS](http://raphaeljs.com/) is primarily used to render the Go board.

* Utility libraries:
	
	* [jQuery](http://jquery.com/)

	* [underscore.js](http://underscorejs.org/)

* All JavaScript files are packaged together with [RequireJS](http://requirejs.org/) and its [optimizer](http://requirejs.org/docs/optimization.html), and minified through [UglifyJS2](https://github.com/mishoo/UglifyJS2).