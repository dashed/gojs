define(["./var/arr", "lodash"], function(lodash) {
  var goban;
  goban = (function() {
    goban.VERSION = '0.1';

    function goban(size_width, size_length) {
      this.size_width = size_width != null ? size_width : 19;
      this.size_length = size_length;
      if (this.size_length == null) {
        this.size_length = this.size_width;
      }
      return;
    }

    goban.prototype.move = function() {};

    return goban;

  })();
  return goban;
});
