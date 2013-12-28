define ["./var/arr", "lodash"], (arr, lodash) ->
  
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


        return

    move: () ->
        return

  return goban