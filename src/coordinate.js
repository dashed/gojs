define([], function() {
  /*
  Define the various coordinate systems for Goban.
  
  See: http://senseis.xmp.net/?Coordinates
  
  Available systems:
  - japanese
  - western
  - matrix
  - cartesian
  
  Coordinates are normalized to row-col matrice convention.
  
  All coordinate systems normalize to [row, col]
  
  For all transformation functions, this.row_bound and this.col_bound are available for use.
  */

  var coordinates, meta_western;
  coordinates = {};
  /*
  1-1 is the origin that begins at the upper left corner, and continues to
  19-19 at the lower-right corner
  
  (row-col convention)
  */

  coordinates['japanese'] = function(row, col) {
    return [row - 1, col - 1];
  };
  meta_western = function(alphabet, _letter, num) {
    var col, letter, row;
    if (!(_.isString(_letter) && _letter.length === 1)) {
      throw new Error('Invalid letter coordinate. Given (#{_letter}, #{num})');
    }
    letter = _letter.toLowerCase();
    col = _.indexOf(alphabet, letter);
    row = this.row_bound - num;
    return [row, col];
  };
  coordinates['western'] = function(_letter, num) {
    return meta_western("abcdefghjklmnopqrstuvwxyz", _letter, num);
  };
  coordinates['western2'] = function(letter, y) {
    return meta_western("abcdefghijklmnopqrstuvwxyz", _letter, num);
  };
  coordinates['matrix'] = function(row, col) {
    return [row, col];
  };
  coordinates['cartesian_zero'] = function(x, y) {
    var col, row;
    col = x;
    row = this.row_bound - y - 1;
    return [row, col];
  };
  coordinates['cartesian_one'] = function(x, y) {
    var col, row;
    col = x - 1;
    row = this.row_bound - y;
    return [row, col];
  };
  return coordinates;
});
