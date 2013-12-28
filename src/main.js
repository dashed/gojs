define(["./var/isInteger", "lodash"], function(isInteger, lodash) {
  var goban;
  console.log(lodash.VERSION);
  goban = (function() {
    goban.VERSION = '0.1';

    function goban(size_width, size_length) {
      this.size_width = size_width != null ? size_width : 19;
      this.size_length = size_length;
      /*
      1. no args: 
          @size_width = @size_length = 19
      
      2. one arg (i.e. @size_width):
          @size_length = @size_width
      
      3. two arg: trivial
      */

      if (this.size_length == null) {
        this.size_length = this.size_width;
      }
      if (!isInteger(this.size_width)) {
        throw new Error("First param of goban (size_width) must be an integer");
      }
      if (!isInteger(this.size_length)) {
        throw new Error("Second param of goban (size_length) must be an integer");
      }
      return;
    }

    goban.prototype.move = function() {};

    return goban;

  })();
  return goban;
});
