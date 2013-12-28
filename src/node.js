var requirejs;

requirejs = require('requirejs');

requirejs(['config', 'main'], function(config, goban) {
  var lol;
  lol = goban(10);
  new goban();
  return console.log(lol);
});
