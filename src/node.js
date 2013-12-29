var requirejs;

requirejs = require('requirejs');

requirejs(['config', 'goban', 'lodash'], function(config, Goban, _) {
  var lol;
  lol = Goban();
  return console.log(lol.config);
});
