define(["lodash"], function(_) {
  /*
  Define the various coordinate systems for Goban.
  
  See: http://senseis.xmp.net/?Coordinates
  
  Available systems:
  - japanese
  - western
  - matrix
  - cartesian
  
  Coordinates are normalized to row-col matrice convention
  */

  var coordinates;
  coordinates = {};
  /*
  1-1 is the origin that begins at the upper left corner, and continues to
  19-19 at the lower-right corner
  
  (X-Y convention)
  */

  coordinates['japanese'] = function(x, y) {};
  coordinates['western'] = function(x, y) {};
  coordinates['matrix'] = function(row, col) {
    if (row < 0) {
      throw new Error('Matrix coordinate (row) should be at least 0.');
    }
    if (col < 0) {
      throw new Error('Matrix coordinate (col) should be at least 0.');
    }
    return [row, col];
  };
  coordinates['cartesian'] = function(x, y) {};
  return coordinates;
});
