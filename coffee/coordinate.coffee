define [], () ->
    ###
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
    ###


    coordinates = {}

    ###
    1-1 is the origin that begins at the upper left corner, and continues to
    19-19 at the lower-right corner

    (X-Y convention)
    ###
    coordinates['japanese'] = (x, y) ->
        return

    coordinates['western'] = (letter, y) ->
        return

    coordinates['matrix'] = (row, col) ->
        return [row, col]

    # zero-based index
    # Assume:
    #   0 <= x < col_bound
    #   0 <= y < row_bound
    coordinates['cartesian_zero'] = (x, y) ->
        col = x
        row = @row_bound - y - 1
        return [row, col]

    # one-based index
    # Assume:
    #   1 <= x <= col_bound
    #   1 <= y <= row_bound
    coordinates['cartesian_one'] = (x, y) ->
        col = x - 1
        row = @row_bound - y
        return [row, col]


    return coordinates
