define(["main", "lodash"], function(Goban, _) {
  /*
  Goban(...) instead of new Goban(...)
  But either is possible.
  */

  var factory;
  factory = function(length, width) {
    return new Goban(length, width);
  };
  _.each(_.keys(Goban), function(key) {
    factory[key] = Goban[key];
  });
  return factory;
});
