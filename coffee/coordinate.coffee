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

    (row-col convention)
    ###
    coordinates['japanese'] = (row, col) ->
        return [row - 1, col - 1]


    meta_western = (alphabet, _letter, num) ->
        if !(_.isString(_letter) and _letter.length is 1)
            throw new Error('Invalid letter coordinate. Given (#{_letter}, #{num})')

        letter = _letter.toLowerCase()

        col = _.indexOf(alphabet, letter)
        row = @row_bound - num
        return [row, col]

    # Note: "I" is not used, historically to avoid confusion with "J"
    # Assume:
    #   A <= _letter <= Z (exclude I)
    #   1 <= num <= row_bound
    coordinates['western'] = (_letter, num) ->
        return meta_western("abcdefghjklmnopqrstuvwxyz", _letter, num)


    coordinates['western2'] = (letter, y) ->
        return meta_western("abcdefghijklmnopqrstuvwxyz", _letter, num)

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
