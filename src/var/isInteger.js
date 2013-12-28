define(function() {
  return function(n) {
    return n === +n && n === (n | 0);
  };
});
