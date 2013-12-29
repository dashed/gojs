var requirejs;

requirejs = require('requirejs');

requirejs(['config', 'goban', 'lodash'], function(config, goban, _) {
  console.log(Object.keys(new goban()));
  return console.log(Object.keys(goban()));
});
