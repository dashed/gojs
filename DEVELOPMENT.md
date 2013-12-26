Development
===========

1. `npm install`

2. Edit coffeescript files in `./coffee/` folder.


Testing
=======

Testing is done using mocha and chai (assert lib).

mocha tests are in coffeescript and placed within the ./test/ folder.

## Code coverage

Code coverage is done with [istanbul](https://github.com/gotwarlost/istanbul) in tandem with mocha.

For code coverage report generation:

`istanbul cover --hook-run-in-context _mocha -- -R spec`

**Note**:

`--hook-run-in-context` is needed to play nicely with requirejs.
See: https://github.com/gotwarlost/istanbul/issues/125