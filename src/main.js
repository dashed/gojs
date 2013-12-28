define(["./var/isInteger", "lodash"], function(isInteger, lodash) {
  var goban;
  console.log(lodash.VERSION);
  goban = (function() {
    goban.VERSION = '0.1';

    function goban(width, length) {
      this.width = width != null ? width : 19;
      this.length = length;
      /*
      1. no args: 
          @width = @length = 19
      
      2. one arg (i.e. @width):
          @length = @width
      
      3. two arg: trivial
      */

      if (this.length == null) {
        this.length = this.width;
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
