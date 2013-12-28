define(["./var/isInteger", "lodash"], function(isInteger, lodash) {
  var goban;
  goban = (function() {
    goban.VERSION = '0.0.1';

    function goban(length, width) {
      this.length = length != null ? length : 19;
      this.width = width;
      /*
      1. no args: 
          @length = @width = 19
      
      2. one arg (i.e. @length):
          @width = @length
      
      3. two arg: trivial
      */

      if (this.width == null) {
        this.width = this.length;
      }
      if (!isInteger(this.width)) {
        throw new Error("First param of goban (width) must be an integer");
      }
      if (!isInteger(this.length)) {
        throw new Error("Second param of goban (length) must be an integer");
      }
      if (this.width <= 0) {
        throw new Error("First param of goban (width) must be at least 1");
      }
      if (this.length <= 0) {
        throw new Error("Second param of goban (length) must be at least 1");
      }
      return;
    }

    goban.prototype.move = function() {};

    return goban;

  })();
  return goban;
});
