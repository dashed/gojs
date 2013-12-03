gojs
====

Go board game in Javascript.

REWRTIE
=======

This git branch is a rewrite of the original gojs library.

The rewrite will include a variety of new features, as well as making the library flexible.

## Features

* SGF parser/writer for game history
* Export SGF (perhaps to github gists)
* Engine is completely independent of gfx (raphaeljs)
* Utilize JS templates (lodash or doT) to customize interface
* Go rule customization: PSK, NSSK, and SSK.
  * Rule presets: Japanese, Chinese, etc.
* Internationalisation support (i18n) to allow translations.
* Complete history support
* Utilize HTML5 features (browser data)
* Multiplayer support

## Proposed repo

The gojs repo should only hold the core library.

* **gojs** - core library
* **SGF-js** - SGF to json (or custom) and vice versa
* **gojs-raphael** - gojs with raphael frontend
* **gojs-goinstant** - gojs with goinstant (multiplayer)

## Ideas

Consider using: https://github.com/bramstein/bit-array

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

[Click here](http://dashed.github.com/gojs/#demo) to view the demo

colophon
========

* All code excluding libraries are written in [coffeescript](http://coffeescript.org/) which compiles into JavaScript.

* [Raphael JS](http://raphaeljs.com/) is primarily used to render the Go board.

* Utility libraries:
	
	* [jQuery](http://jquery.com/)

	* [underscore.js](http://underscorejs.org/)

* All JavaScript files are packaged together with [RequireJS](http://requirejs.org/) and its [optimizer](http://requirejs.org/docs/optimization.html), and minified through [UglifyJS2](https://github.com/mishoo/UglifyJS2).


License
=======

MIT License

