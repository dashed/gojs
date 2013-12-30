define [], () ->

    ###
    Represent the board in 1D array.

    1D array is get/set in row-major order.
    ###

    class Board

        constructor: (@row, @col, value=undefined) ->

            @col ?= @row

            # Define the board array
            @board = []

            if(value isnt undefined)
                @setDefault(value)

        # Fill entire array with default value
        setDefault: (value) ->

            n = @row * @col

            while n-- > 0
                @board.push(value)

            return @

        getBoard: () ->
            return @board

        get: (row, col) ->
            return @board[row * @col + col]

        set: (value, row, col) ->
            @board[row * @col + col] = value
            return @


    return Board
