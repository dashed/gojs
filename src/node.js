var requirejs;

requirejs = require('requirejs');

requirejs(['config', 'main'], function(config, goban) {
  var lol;
  lol = new goban();
  return console.log(lol.size_width);
});
