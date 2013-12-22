requirejs = require('requirejs')
Mocha = require('mocha')

mocha = new Mocha;

# Configure mocha
# https://github.com/visionmedia/mocha/wiki/Using-mocha-programmatically
mocha.reporter('spec').ui('bdd');

# Add specs
mocha.addFile('spec/goban.js');

# Run mocha
mocha.run (failures) ->
  process.on "exit", ->
    process.exit failures