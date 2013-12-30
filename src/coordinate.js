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

  var coordinates;
  coordinates = {};
  /*
  1-1 is the origin that begins at the upper left corner, and continues to
  19-19 at the lower-right corner
  
  (X-Y convention)
  */

  coordinates['japanese'] = function(x, y) {};
  coordinates['western'] = function(letter, y) {};
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
