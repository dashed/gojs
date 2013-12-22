define ["./var/arr", "lodash"], (lodash) ->
  
  class goban

    @VERSION: '0.1'

    constructor: (@size_width=19, @size_length) ->

        # if @size_length == null then @size_length = @size_width
        @size_length ?= @size_width
        
        return

    move: () ->
        return

  return goban