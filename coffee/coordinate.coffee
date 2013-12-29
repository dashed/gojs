define ["lodash"], (_) ->
    ###
    Define the various coordinate systems for Goban.

    See: http://senseis.xmp.net/?Coordinates

    Available systems:
    - japanese
    - western
    - matrix
    - cartesian

    Coordinates are normalized to row-col matrice convention
    ###

    coordinates = {}

    ###
    1-1 is the origin that begins at the upper left corner, and continues to
    19-19 at the lower-right corner

    (X-Y convention)
    ###
    coordinates['japanese'] = (x, y) ->
        return

    coordinates['western'] = (x, y) ->
        return

    coordinates['matrix'] = (row, col) ->

        if row < 0 then throw new Error('Matrix coordinate (row) should be at least 0.')
        if col < 0 then throw new Error('Matrix coordinate (col) should be at least 0.')

        return [row, col]

    coordinates['cartesian'] = (x, y) ->
        return

    return coordinates
