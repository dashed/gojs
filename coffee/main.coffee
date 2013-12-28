define ["./var/isInteger", "lodash"], (isInteger, lodash) ->
  
  console.log(lodash.VERSION)

  class goban

    @VERSION: '0.1'

    constructor: (@size_width=19, @size_length) ->

        ###
        1. no args: 
            @size_width = @size_length = 19

        2. one arg (i.e. @size_width):
            @size_length = @size_width

        3. two arg: trivial
        ###

        # if @size_length === null then @size_length = @size_width
        @size_length ?= @size_width

        if !isInteger(@size_width) then throw new Error("First param of goban (size_width) must be an integer")
        if !isInteger(@size_length) then throw new Error("Second param of goban (size_length) must be an integer")

        return

    move: () ->
        return

  return goban