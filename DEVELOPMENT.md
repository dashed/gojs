Development
===========

1. `npm install`

2. Run `gulp` to watch coffeescript files.

3. Edit coffeescript files in `./coffee/` folder.

Gulp
====

[Gulp](https://github.com/wearefractal/gulp) is used as an alternative of gruntjs for the build system.

Testing
=======

Testing is done using mocha and chai (assert lib). Tests/specs are written in coffeescript and placed within the ./test/ folder.

To run the tests:

`npm test`

To run the tests and generate the coverage report:

`npm test --coverage`

**Note:** `--coverage` flag requires node 0.6 or better.


## Code coverage

Code coverage is done with [istanbul](https://github.com/gotwarlost/istanbul) in tandem with mocha.

For code coverage report generation:

`istanbul cover --hook-run-in-context _mocha -- -R spec`

**Note**:

`--hook-run-in-context` is needed to play nicely with requirejs.
See: https://github.com/gotwarlost/istanbul/issues/125