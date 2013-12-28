define ["./var/isInteger", "lodash"], (isInteger, lodash) ->
  
  console.log(lodash.VERSION)

  class goban

    @VERSION: '0.1'

    constructor: (@width=19, @length) ->

        ###
        1. no args: 
            @width = @length = 19

        2. one arg (i.e. @width):
            @length = @width

        3. two arg: trivial
        ###

        # if @length === null then @length = @width
        @length ?= @width

        if !isInteger(@width) then throw new Error("First param of goban (width) must be an integer")
        if !isInteger(@length) then throw new Error("Second param of goban (length) must be an integer")

        if @width <= 0 then throw new Error("First param of goban (width) must be at least 1")
        if @length <= 0 then throw new Error("Second param of goban (length) must be at least 1")

        return

    move: () ->
        return

  return goban