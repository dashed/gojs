define ["./var/isInteger", "lodash"], (isInteger, lodash) ->

  class goban

    @VERSION: '0.0.1'

    constructor: (@length=19, @width) ->

        ###
        1. no args: 
            @length = @width = 19

        2. one arg (i.e. @length):
            @width = @length

        3. two arg: trivial
        ###

        # if @width === null then @width = @length
        @width ?= @length

        # Ensure param(s) is/are integer(s)
        if !isInteger(@width) then throw new Error("First param of goban (width) must be an integer")
        if !isInteger(@length) then throw new Error("Second param of goban (length) must be an integer")

        # Ensure param(s) is/are not zero
        if @width <= 0 then throw new Error("First param of goban (width) must be at least 1")
        if @length <= 0 then throw new Error("Second param of goban (length) must be at least 1")

        return

    move: () ->
        return

  return goban